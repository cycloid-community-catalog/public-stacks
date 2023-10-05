#!/bin/bash
export TEAM_ID="${TEAM_ID}"
export WORKER_KEY="${WORKER_KEY}"
export VAR_LIB_DEVICE="nodevice"
export CLOUD_PROVIDER="baremetal"

exec &> >(tee -a /var/log/user-data.log)

curl -sSL "https://raw.githubusercontent.com/cycloid-community-catalog/stack-external-worker/master/extra/startup.sh?$RANDOM" | bash