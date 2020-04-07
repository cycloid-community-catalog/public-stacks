#/usr/bin/env bash

set -ex

export LOG_FILE="/var/log/user-data.log"
exec &> >(tee -a ${LOG_FILE})

# Project name, env and role used in the concourse worker naming.
export PROJECT=${PROJECT:-"cycloid-ci-workers"}
export ENV=${ENV:-"prod"}
export ROLE=${ROLE:-"workers"}

# Informations needed to connect to Cycloid SaaS Concourse.
export SCHEDULER_API_ADDRESS=${SCHEDULER_API_ADDRESS:-"https://scheduler.cycloid.io"}
export SCHEDULER_HOST=${SCHEDULER_HOST:-"scheduler.cycloid.io"}
export SCHEDULER_PORT=${SCHEDULER_PORT:-"32223"}
export TSA_PUBLIC_KEY=${TSA_PUBLIC_KEY:-"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+To6R1hDAO00Xrt8q5Md38J9dh+aMIbV2GTqQkFcKwVAB6czbPPcitPWZ7y3Bw1dKMC8R7DGRAt01yWlkYo/voRp5prqKMc/uzkObhHNy42eJgZlStKU1IMw/fx0Rx+6Y3NClCCOecx415dkAH+PFudKosq4pFB9KjfOp3tMHqirMSF7dsbM3910gcPBL2NFHkOZ4cNfeSztXEg9wy4SExX3CHiUyLiShpwXa+C2f6IPdOJt+9ueXQIL0hcMmd12PRL5UU6/e5U5kldM4EWiJoohVbfoA1CRFF9QwJt6H3IiZPmd3sWqIVVy6Vssn5okjYLRwCwEd8+wd8tI6OnNb"}

# Dedicated device used by the concourse worker for storage.
# This device will be formatted to btrfs.
export VAR_LIB_DEVICE=${VAR_LIB_DEVICE:-"/dev/nvme1n1"}

# SSH public key used by the worker to be able to join the Cycloid SaaS Concourse.
# Go to your Cycloid Credentials, find the `cycloid-worker-keys` credential
# and copy the value of the private key here encoded in base64.
export WORKER_KEY=${WORKER_KEY:-"<BASE64_ENCODED_CYCLOID_WORKER_PRIVATE_KEY>"}

# Cycloid team ID that can be found on the organization view page.
export TEAM_ID=${TEAM_ID:-"XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX"}

# Branch of the external-worker stack to use for the install, should be master in most cases.
# @see https://github.com/cycloid-community-catalog/stack-external-worker
export STACK_BRANCH=${STACK_BRANCH:-"master"}

# Run the installation script.
# The $RANDOM variable is here used to avoid remote network caching.
curl -sSL "https://raw.githubusercontent.com/cycloid-community-catalog/stack-external-worker/${STACK_BRANCH}/extra/startup.sh?${RANDOM}" | bash
