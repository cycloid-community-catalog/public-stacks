#!/usr/bin/env bash

export PROJECT=cycloid-scaleway-worker-1
export TEAM_ID="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX"
export WORKER_KEY="<BASE64_ENCODED_CYCLOID_WORKER_PRIVATE_KEY>"

export LOG_FILE="/var/log/user-data.log"
exec &> >(tee -a ${LOG_FILE})

# Run the startup installation script.
# The $RANDOM variable is here used to avoid remote network caching.
curl -sSL "https://raw.githubusercontent.com/cycloid-community-catalog/stack-external-worker/master/extra/startup.sh?${RANDOM}" | bash -s scaleway
