#!/bin/sh

export SCHEDULER_HOST="${SCHEDULER_HOST:-scheduler.cycloid.io}"
export SCHEDULER_PORT="${SCHEDULER_PORT:-32223}"
export TSA_PUBLIC_KEY="${TSA_PUBLIC_KEY:-ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+To6R1hDAO00Xrt8q5Md38J9dh+aMIbV2GTqQkFcKwVAB6czbPPcitPWZ7y3Bw1dKMC8R7DGRAt01yWlkYo/voRp5prqKMc/uzkObhHNy42eJgZlStKU1IMw/fx0Rx+6Y3NClCCOecx415dkAH+PFudKosq4pFB9KjfOp3tMHqirMSF7dsbM3910gcPBL2NFHkOZ4cNfeSztXEg9wy4SExX3CHiUyLiShpwXa+C2f6IPdOJt+9ueXQIL0hcMmd12PRL5UU6/e5U5kldM4EWiJoohVbfoA1CRFF9QwJt6H3IiZPmd3sWqIVVy6Vssn5okjYLRwCwEd8+wd8tI6OnNb}"

export CONCOURSE_GARDEN_LOG_LEVEL="error"

usage()
{
    echo 'You should provide the following env vars :'
    echo ''
    echo "$0"
    echo '  * `TEAM_ID` : Cycloid CI team ID'
    echo '  * `WORKER_KEY` : Cycloid CI worker private key. Base64 encoded'
    echo ''
    exit 1
}

if [ -z "$TEAM_ID" ] ||
[ -z "$WORKER_KEY" ]; then
usage
fi

echo $TSA_PUBLIC_KEY > /usr/local/concourse/host_key.pub
echo $WORKER_KEY | base64 -d > /usr/local/concourse/worker_key

echo "Starting cycloid worker"
exec /usr/local/concourse/bin/concourse worker \
  --team $TEAM_ID \
  --tsa-host "$SCHEDULER_HOST:$SCHEDULER_PORT" \
  --tsa-public-key /usr/local/concourse/host_key.pub \
  --tsa-worker-private-key /usr/local/concourse/worker_key \
  --name $(hostname) \
  --ephemeral $@
