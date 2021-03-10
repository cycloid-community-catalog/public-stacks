#!/usr/bin/env bash

if test -z "$BASH_VERSION"; then
  echo "Please run this script using bash, not sh or any other shell." >&2
  exit 1
fi

# We wrap the entire script in a big function which we only call at the very end, in order to
# protect against the possibility of the connection dying mid-script. This protects us against
# the problem described in this blog post:
#   https://www.seancassidy.me/dont-pipe-to-your-shell.html
#   https://www.idontplaydarts.com/2016/04/detecting-curl-pipe-bash-server-side/
_() {
    set -euo pipefail

    # Run the setup in debug mode.
    DEBUG=${DEBUG:-0}
    # Concourse worker version to use. By default, the same version as the Concourse server will be used.
    VERSION=${VERSION:-""}
    # Branch of the external-worker stack to use for the install, should be master in most cases.
    STACK_BRANCH=${STACK_BRANCH:-"master"}

    # Project name, env and role used in the concourse worker naming.
    PROJECT=${PROJECT:-"cycloid-ci-workers"}
    ROLE="${ROLE:-"workers"}"
    ENV="${ENV:-"prod"}"

    # Install user
    INSTALL_USER=${INSTALL_USER:-""}

    # Dedicated device used by the concourse worker for storage.
    # This device will be formatted to btrfs.
    USE_LOCAL_DEVICE=${USE_LOCAL_DEVICE:-0}
    VAR_LIB_DEVICE=${VAR_LIB_DEVICE:-""}

    # Informations needed to connect to Concourse. Defaults to the Cycloid SaaS.
    SCHEDULER_API_ADDRESS=${SCHEDULER_API_ADDRESS:-"https://scheduler.cycloid.io"}
    SCHEDULER_HOST=${SCHEDULER_HOST:-"scheduler.cycloid.io"}
    SCHEDULER_PORT=${SCHEDULER_PORT:-"32223"}
    TSA_PUBLIC_KEY=${TSA_PUBLIC_KEY:-"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+To6R1hDAO00Xrt8q5Md38J9dh+aMIbV2GTqQkFcKwVAB6czbPPcitPWZ7y3Bw1dKMC8R7DGRAt01yWlkYo/voRp5prqKMc/uzkObhHNy42eJgZlStKU1IMw/fx0Rx+6Y3NClCCOecx415dkAH+PFudKosq4pFB9KjfOp3tMHqirMSF7dsbM3910gcPBL2NFHkOZ4cNfeSztXEg9wy4SExX3CHiUyLiShpwXa+C2f6IPdOJt+9ueXQIL0hcMmd12PRL5UU6/e5U5kldM4EWiJoohVbfoA1CRFF9QwJt6H3IiZPmd3sWqIVVy6Vssn5okjYLRwCwEd8+wd8tI6OnNb"}

    # Cycloid team ID that can be found on the organization view page.
    TEAM_ID=${TEAM_ID:-""}

    # SSH public key used by the worker to be able to join the Concourse server.
    # Go to your Cycloid Credentials, find the `cycloid-worker-keys` credential
    # and copy the value of the private key here encoded in base64.
    # This variable can be ignored if you plan to get it from Vault.
    WORKER_KEY=${WORKER_KEY:-""}

    # Vault
    VAULT_URL=${VAULT_URL:-"https://vault.cycloid.io"}
    VAULT_ROLE_ID=${VAULT_ROLE_ID:-""}
    VAULT_SECRET_ID=${VAULT_SECRET_ID:-""}
    # Make sure there is no trailling slash.
    VAULT_URL=${VAULT_URL%/}

    # Specify a supported Cloud Provider to handle specifities related to it. Some settings will be automatically set if not overriden.
    CLOUD_PROVIDER=${CLOUD_PROVIDER:-""}

    # AWS
    # For backward compatibility with older deployments.
    STACK_NAME="${STACK_NAME:-$PROJECT}"

    # GCP
    RUNTIMECONFIG_NAME=${RUNTIMECONFIG_NAME:-""}

    cloud_signal_status() {
        local status="$1"
        if [[ ${CLOUD_PROVIDER} == "aws" ]]; then
            aws cloudformation signal-resource --stack-name ${STACK_NAME} --logical-resource-id WorkersGroup --unique-id ${AWS_UNIQUE_ID} --region ${AWS_DEFAULT_REGION} --status ${status^^}
        elif [[ ${CLOUD_PROVIDER} == "gcp" ]]; then
            gcloud beta runtime-config configs variables set "${status,,}/worker" ${status,,} --config-name ${RUNTIMECONFIG_NAME}-runtimeconfig
        fi
    }

    finish() {
        if [[ $? -eq 0 ]]; then
            echo "[startup.sh] SUCCESS"
            cloud_signal_status SUCCESS
        else
            set +e
            echo "[startup.sh] FAILURE"
            echo "[startup.sh] waiting 1min for debug purpose, create a /tmp/keeprunning file to prevent halting the instance"
            sleep 60
            if [[ -f "/tmp/keeprunning" ]]; then
                echo "[startup.sh] keeprunning"
                cloud_signal_status SUCCESS
            else
                echo "[startup.sh] halting"
                cloud_signal_status FAILURE
                halt -p
            fi
        fi
    }
    trap finish EXIT

    usage() {
        echo "Usage: $SCRIPT_NAME [-d] [-b BRANCH_NAME] [<cloud_provider>]" >&2
        echo "The <cloud_provider> argument is optional, it can be either `aws`, `azure`, `gcp`, `flexible-engine`, `scaleway` or `baremetal`." >&2
        echo '' >&2
        echo '  -d           Debug mode.' >&2
        echo '  -b           Branch to use for the external-worker stack (default: master).' >&2
        exit 1
    }

    handle_args() {
        SCRIPT_NAME=$1
        shift

        while getopts ":deiup:" opt; do
            case $opt in
            d)
                DEBUG=1
                ;;
            b)
                STACK_BRANCH="${OPTARG}"
                ;;
            *)
                usage
                ;;
            esac
        done

        # Pass positional parameters through
        shift "$((OPTIND - 1))"

        if [[ $# -eq 1 ]] && [[ ! $1 =~ ^- ]]; then
            CLOUD_PROVIDER="$1"
        elif [[ $# -ne 0 ]]; then
            usage
        fi
    }

    handle_envvars() {
        [[ -z "${TEAM_ID}" ]] && echo "error: TEAM_ID envvar must be set." >&2 && exit 2

        # If WORKER_KEY is not provided, try others methods
        if [[ -z "${WORKER_KEY}" ]] && [[ -z "${VAULT_SECRET_ID}" || -z "${VAULT_SECRET_ID}" ]] ; then
            echo "error: WORKER_KEY or VAULT_SECRET_ID && VAULT_SECRET_ID envvar must be set." >&2 && exit 2
        fi

        # GCP
        if [[ "${CLOUD_PROVIDER}" == "gcp" ]]; then
            [[ -z "${RUNTIMECONFIG_NAME}" ]] && echo "error: RUNTIMECONFIG_NAME envvar must be set." >&2
        fi

        if [[ -z "${INSTALL_USER}" ]]; then
            if [[ "${CLOUD_PROVIDER}" == "scaleway" ]]; then
                INSTALL_USER="root"
            else
                INSTALL_USER="admin"
            fi
        fi

        # Define device to use depending on the CloudProvider
        if [[ -z "${VAR_LIB_DEVICE}" ]]; then
            if [[ "${CLOUD_PROVIDER}" == "gcp" ]]; then
                VAR_LIB_DEVICE="/dev/disk/by-id/google-data-volume"
            elif [[ "${CLOUD_PROVIDER}" == "aws" ]]; then
                VAR_LIB_DEVICE="/dev/xvdf"
            elif [[ "${CLOUD_PROVIDER}" == "azure" ]]; then
                VAR_LIB_DEVICE="/dev/disk/azure/scsi1/lun0"
            elif [[ "${CLOUD_PROVIDER}" == "flexible-engine" ]]; then
                VAR_LIB_DEVICE="/dev/vdb"
            elif [[ "${CLOUD_PROVIDER}" == "scaleway" ]]; then
                if [[ ${USE_LOCAL_DEVICE} -eq 1 ]]; then
                    VAR_LIB_DEVICE="/dev/vdb"
                else
                    VAR_LIB_DEVICE="/dev/sda"
                fi
            else
                VAR_LIB_DEVICE="nodevice"
            fi
        fi

        if [[ ${DEBUG} == "true" ]]; then
            DEBUG=1
        else
            DEBUG=0
        fi
    }

    handle_args "$@"
    handle_envvars

    echo "### starting setup of cycloid worker"

    # Avoid apt lock issue if there is another apt process at startup.
    # This is mostly the case with agent like waagent on Azure.
    timeout 300 bash -c "while pgrep apt > /dev/null; do sleep 1; done"

    apt-get update
    apt-get install -yqq --no-install-recommends libssl-dev libffi-dev python3-dev python3-setuptools python3-pip git curl jq cargo

    cd /opt/
    git clone -b ${STACK_BRANCH} https://github.com/cycloid-community-catalog/stack-external-worker
    cd stack-external-worker/ansible

    python3 -m pip install -U pip
    python3 -m pip install -r requirements.txt
    python3 -m pip install ansible==2.9.*

    # Get WORKER_KEY from Vault
    if [[ -z "${WORKER_KEY}" ]] && [[ -n "${VAULT_SECRET_ID}" && -n "${VAULT_ROLE_ID}" ]] ; then
        TOKEN=$(curl -sSL --request POST --data "{\"role_id\":\"$VAULT_ROLE_ID\",\"secret_id\":\"$VAULT_SECRET_ID\"}" $VAULT_URL/v1/auth/approle/login | jq -r '.auth.client_token')
        export WORKER_KEY=$(curl -sSL -H "X-Vault-Token: $TOKEN" -X GET $VAULT_URL/v1/cycloid/$TEAM_ID/cycloid-worker-keys | jq  -r .data.ssh_prv | base64 -w0)
    fi

    # Make sure WORKER_KEY looks ok
    TMP_WORKER_KEY=$(mktemp)
    echo $WORKER_KEY | base64 -d > $TMP_WORKER_KEY
    chmod 400 $TMP_WORKER_KEY
    ssh-keygen -l -f $TMP_WORKER_KEY > /dev/null 2>&1 || echo "error: WORKER_KEY Does not seems to be an SSH PRIVATE KEY." >&2 && exit 2

    if [[ "${CLOUD_PROVIDER}" == "aws" ]]; then
        python3 -m pip install awscli

        # Be able to use paris region (https://github.com/boto/boto/issues/3783)
        python3 -m pip install --upgrade boto
        echo '[Boto]
use_endpoint_heuristics = True' > /etc/boto.cfg

        export AWS_DEFAULT_REGION=$(curl -sL http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
        export AWS_UNIQUE_ID=$(curl -L http://169.254.169.254/latest/meta-data/instance-id)
    fi

    if [[ "${INSTALL_USER}" == "root" ]]; then
        export HOME="/root"
    else
        export HOME="/home/${INSTALL_USER}"
    fi
    # Remove spaces because some CloudProvider don't support empty parametter so their default value contain one space as empty
    export VERSION=${VERSION// /}
    export VERSION=${VERSION:-$(curl -skL "${SCHEDULER_API_ADDRESS}/api/v1/info" | jq -r '.version')}

    cat >> "${ENV}-worker.yml" <<EOF
concourse_version: "${VERSION}"
concourse_tsa_port: "${SCHEDULER_PORT}"
concourse_tsa_host: "${SCHEDULER_HOST}"
concourse_tsa_public_key: "${TSA_PUBLIC_KEY}"
concourse_tsa_worker_key_base64: "${WORKER_KEY}"
concourse_tsa_worker_key: "{{ concourse_tsa_worker_key_base64 | b64decode}}"
concourse_worker_team: "${TEAM_ID}"
nvme_mapping_run: true
install_user: ${INSTALL_USER}
use_local_device: ${USE_LOCAL_DEVICE}
var_lib_device: ${VAR_LIB_DEVICE}
cloud_provider: ${CLOUD_PROVIDER}
EOF

    ansible-galaxy install -r requirements.yml --force --roles-path=/etc/ansible/roles

    set -x
    echo "Run packer.yml"
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook -e role=${ROLE} -e env=${ENV} -e project=${PROJECT} --connection local packer.yml

    echo "Run external-worker.yml build steps"
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook -e role=${ROLE} -e env=${ENV} -e project=${PROJECT} --connection local external-worker.yml --diff --skip-tags deploy,notforbuild

    echo "Run ${HOME}/first-boot.yml"
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook -e role=${ROLE} -e env=${ENV} -e project=${PROJECT} --connection local "${HOME}/first-boot.yml" --diff

    echo "Run external-worker.yml boot steps"
    ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook -e role=${ROLE} -e env=${ENV} -e project=${PROJECT} --connection local external-worker.yml --diff --tags runatboot,notforbuild
    set +x

    sleep 60 && systemctl status concourse-worker
}

# Now that we know the whole script has downloaded, run it.
_ "$0" "$@"
