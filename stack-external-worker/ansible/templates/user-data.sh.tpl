#!/bin/bash -x
#
# This script is deployed by packer during the AMI creation and executed via
# the user-data set by the ASG.
#
# It takes care of finishing the configuration of the instance by running
# various playbooks.
#  * One for the configuration of services
#  * and one for the deployment of the code.
#
# Relics from the AMI (hostname/IP addresses) etc should be removed during the
# run, to end-up with a neat image.
#
# Once the code is deployed, the instance should be ready to serve content.
#
# If anything goes wrong during this script, the instance will be shut down
# while everything should be logged into a log file to be easily debuggable.
#
# If the script runs fine it should remove everything it has used to leave a
# clean configured instance running - except the logs.
#
# N.B.: The script itself should be deleted if it ran fine.
#

set -x

LOG_FILE="/var/log/user-data.log"

###  ansible issue when run at boot : https://github.com/ansible/ansible/issues/21562
export HOME="{{ install_user_home }}"
export ANSIBLE_LOCAL_TEMP="${HOME}/.ansible/tmp"
export ANSIBLE_REMOTE_TEMP="${HOME}/.ansible/tmp"
###

ANSIBLE_PLAYBOOK="${HOME}/first-boot.yml"
# Path is related to https://github.com/cycloidio/ansible-customer-ssh/blob/master/tasks/main.yml#L32
ANSIBLE_DEPLOYMENT_PLAYBOOK="${HOME}/${PROJECT}/external-worker.yml"

# Output both to stdout and to ${LOG_FILE}
exec &> >(tee -a ${LOG_FILE})

log() {
	echo "$(date) ${HOSTNAME} USER-DATA[${$}]: ${USER} ${*}"
}

log "Starting ${0} script"
log "Checking ${ANSIBLE_PLAYBOOK} file"

if [ ! -f "${ANSIBLE_PLAYBOOK}" ]; then
	log "${ANSIBLE_PLAYBOOK} file doesn't exist."
	log "Stopping here."
	log "Finishing ${0} script"
	#poweroff
	exit 1
fi

log "File ${ANSIBLE_PLAYBOOK} exists."
log "Starting ${ANSIBLE_PLAYBOOK} playbook"

ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook ${ANSIBLE_PLAYBOOK} --diff \
    -e "customer=${CUSTOMER}" \
    -e "project=${PROJECT}" \
    -e "env=${ENV}" \
    -e "role=${ROLE}" \
    --connection=local
FIRST_BOOK_STATUS=${?}

if [[ "${FIRST_BOOK_STATUS}" != "0" ]]; then
    log "Error running ${ANSIBLE_PLAYBOOK} playbook"
    log "Stopping the instance"
    #poweroff
    exit 1
fi

log "Finished ${ANSIBLE_PLAYBOOK} playbook"

log "Run code deployment"

ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook ${ANSIBLE_DEPLOYMENT_PLAYBOOK} --diff \
            -e "customer=${CUSTOMER}" \
            -e "project=${PROJECT}" \
            -e "env=${ENV}" \
            -e "role=${ROLE}" \
            -e "ec2_tag_customer=${CUSTOMER}" \
            -e "ec2_tag_project=${PROJECT}" \
            -e "ec2_tag_env=${ENV}" \
            -e "ec2_tag_role=${ROLE}" \
            --tags="runatboot,notforbuild" \
            --connection=local
DEPLOY_STATUS=${?}

if [[ "${DEPLOY_STATUS}" != "0" ]]; then
    log "Error running ${ANSIBLE_DEPLOYMENT_PLAYBOOK} playbook"
    log "Stopping the instance"
    #poweroff
    exit 1
fi

log "Finished running code deployment"

log "Removing playbooks"
rm -rf "${HOME}/first-boot.yml" "${HOME}/${PROJECT}" "${ANSIBLE_LOCAL_TEMP}"
log "Finishing ${0} script and removing it"
rm ${0}
