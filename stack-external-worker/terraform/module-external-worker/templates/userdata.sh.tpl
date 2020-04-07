#!/bin/bash -v

set -e

function finish {
    if [ $rc != 0 ]; then
      echo "cloudformation signal-resource FAILURE" >> $LOG_FILE
      /usr/local/bin/aws cloudformation signal-resource --stack-name ${signal_stack_name} --logical-resource-id ${signal_resource_id} --unique-id $${AWS_UNIQUE_ID} --region $${AWS_DEFAULT_REGION} --status FAILURE  2>&1 >> $LOG_FILE

      echo "[halt] 3 min before shutdown" >> $LOG_FILE
      echo "[debug] keep up by creating /var/tmp/keeprunning" >> $LOG_FILE
      sleep 180

      if [ ! -f "/var/tmp/keeprunning" ]; then
        echo "[halt] halt" >> $LOG_FILE
        halt -f
      fi
      echo "[halt] keeprunning" >> $LOG_FILE
    fi
}

trap 'rc=$?; set +e; finish' EXIT

export ENV=${env}
export PROJECT=${project}
export ROLE=${role}

LOG_FILE="/var/log/user-data.log"

export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
AWS_UNIQUE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

#TMP fix for https://github.com/boto/boto/issues/3783
echo '[Boto]
use_endpoint_heuristics = True' > /etc/boto.cfg

bash /home/admin/user-data.sh

# aws cloudformation signal-resource get return code 255 when CF is not updating (for example on scale up)
set +e
/usr/local/bin/aws cloudformation signal-resource --stack-name ${signal_stack_name} --logical-resource-id ${signal_resource_id} --unique-id $${AWS_UNIQUE_ID} --region $${AWS_DEFAULT_REGION} --status SUCCESS  2>&1 >> $LOG_FILE

# ensure last return code is 0
echo "End" >> $LOG_FILE
