#!/bin/bash -v

set -e

function finish {
    if [ $rc != 0 ]; then
      echo "[halt] 3 min before shutdown" >> $LOG_FILE
      echo "[debug] keep up by creating /tmp/keeprunning" >> $LOG_FILE
      sleep 180

      if [ ! -f "/tmp/keeprunning" ]; then
        echo "[halt] halt" >> $LOG_FILE
        halt -f
      fi
      echo "[halt] keeprunning" >> $LOG_FILE
    fi
}

trap 'rc=$?; set +e; finish' EXIT

export CUSTOMER=${customer}
export PROJECT=${project}
export ENV=${env}
export ROLE=${role}

LOG_FILE="/var/log/user-data.log"

bash /root/user-data.sh

# ensure last return code is 0
echo "End" >> $LOG_FILE
