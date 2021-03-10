#!/usr/bin/env bash

export PROJECT=cycloid-scaleway-worker-1
export TEAM_ID="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX"
export WORKER_KEY="<BASE64_ENCODED_CYCLOID_WORKER_PRIVATE_KEY>"

# If you decided to split the default local SSD in two volumes: root and concourse
# export USE_LOCAL_DEVICE=1

# custom branch for debugging/testing purposes
export STACK_BRANCH="master"

export LOG_FILE="/var/log/user-data.log"
exec &> >(tee -a ${LOG_FILE})

# Run the startup installation script.
# The $RANDOM variable is here used to avoid remote network caching.
wget -qO- "https://raw.githubusercontent.com/cycloid-community-catalog/stack-external-worker/${STACK_BRANCH}/extra/startup.sh?${RANDOM}" | bash -s scaleway
