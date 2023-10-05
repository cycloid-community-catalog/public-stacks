#!/bin/bash -v

set -e

function finish {
    if [ $rc != 0 ]; then
      echo "cloudformation signal-resource FAILURE" >> $LOG_FILE
      aws cloudformation signal-resource --stack-name ${signal_stack_name} --logical-resource-id ${signal_resource_id} --unique-id $${AWS_UNIQUE_ID} --region $${AWS_REGION} --status FAILURE  2>&1 >> $LOG_FILE

      echo "[halt] 3 min before shutdown" >> $LOG_FILE
      echo "[debug] keep up by creating /tmp/keeprunning" >> $LOG_FILE
      sleep 60

      if [ ! -f "/tmp/keeprunning" ]; then
        echo "[halt] halt" >> $LOG_FILE
        halt -f
      fi
      echo "[halt] keeprunning" >> $LOG_FILE
    else
      aws cloudformation signal-resource --stack-name ${signal_stack_name} --logical-resource-id ${signal_resource_id} --unique-id $${AWS_UNIQUE_ID} --region $${AWS_REGION} --status SUCCESS  2>&1 >> $LOG_FILE

      # ensure last return code is 0
      echo "End" >> $LOG_FILE
    fi
}

trap 'rc=$?; set +e; finish' EXIT

LOG_FILE="/var/log/user-data.log"

export AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export AWS_UNIQUE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

/etc/eks/bootstrap.sh \
    --apiserver-endpoint '${apiserver_endpoint}' \
    --b64-cluster-ca '${b64_cluster_ca}' \
    --dns-cluster-ip 172.20.0.10 \
    --use-max-pods false \
    '${cluster_name}' \
    ${bootstrap_args} 2>&1 >> $LOG_FILE
