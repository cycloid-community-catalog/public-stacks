# Cycloid local worker

Run a local Cycloid worker using docker see more about it here : [docs.cycloid.io](https://docs.cycloid.io/cycloid-worker-deployment.html)

```
export CYCLOID_WORKER_KEY=$(base64 -w 0)
export CYCLOID_WORKER_TEAM="<cycloid team id>"

docker run -it --rm --privileged --name cycloid-worker -e TEAM_ID=$CYCLOID_WORKER_TEAM -e WORKER_KEY=$CYCLOID_WORKER_KEY cycloid/local-worker
```
