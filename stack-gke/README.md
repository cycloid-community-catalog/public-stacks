# stack-gke

This stack will create a Google Kubernetes Engine cluster with it's own dedicated VPC and one or more node pools.

  * Google Virtual Private Network (VPC)
  * Google Kubernetes Engine
  * Google Kubernetes Engine Node Pools

# Architecture

<p align="center">
<img src="docs/diagram.png" width="400">
</p>


  * **VPC**: Google Virtual Private Network
  * **GKE**: Google Kubernetes Engine

# Requirements

In order to run this task, couple elements are required within the infrastructure:

  * Having an Google Cloud Storage bucket to store Terraform remote states [Here](https://cloud.google.com/storage/docs/creating-buckets).
  * Having the `Compute Engine API` and `Kubernetes Engine API` Services APIs enabled for your Google Cloud project ([documentation](https://cloud.google.com/endpoints/docs/openapi/enable-api#console)).

# Details

## Pipeline

> **Note** The pipeline contains a manual approval between terraform plan and terraform apply.
> That means if you trigger a terraform plan, to apply it, you have to go on terraform apply job
> and click on the `+` button to trigger it.

<img src="docs/pipeline.png" width="800">

**Jobs description**

  * `terraform-plan`: Terraform job that will simply make a plan of the stack.
  * `terraform-apply`: Terraform job similar to the plan one, but will actually create/update everything that needs to. Please see the plan diff for a better understanding.
  * `terraform-destroy`: :warning: Terraform job meant to destroy the whole stack - **NO CONFIRMATION ASKED**. If triggered, the full project **WILL** be destroyed. Use with caution.

**Params**

Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-eks.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`gcp_credentials_json`|Google Cloud Platform credentials JSON for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((gcp_credentials.json))`|`True`|
|`gcp_project`|Google Cloud Platform project to use for Terraform.|`-`|`kubernetes-gke`|`True`|
|`gcp_region`|Google Cloud Platform region to use for Terraform.|`-`|`europe-west1`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|Google Cloud Storage bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'0.12.17'`|`True`|


## Terraform

**Inputs**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`cluster_regional`|If the GKE Cluster must be regional or zonal. Be careful, this setting is destructive.|`-`|`false`|`False`|
|`cluster_release_channel`|GKE Cluster release channel to use. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE.|`-`|`UNSPECIFIED`|`False`|
|`cluster_version`|GKE Cluster version to use.|`-`|`latest`|`False`|
|`default_max_pods_per_node`|The maximum number of pods to schedule per node.|`-`|`110`|`False`|
|`enable_binary_authorization`|Enable GKE Cluster BinAuthZ Admission controller.|`-`|`false`|`False`|
|`enable_cloudrun`|Enable GKE Cluster Cloud Run for Anthos addon.|`-`|`false`|`False`|
|`enable_horizontal_pod_autoscaling`|Enable GKE Cluster horizontal pod autoscaling addon.|`-`|`true`|`False`|
|`enable_http_load_balancing`|Enable GKE Cluster HTTP load balancing addon.|`-`|`false`|`False`|
|`enable_istio`|Enable GKE Cluster Istio addon.|`-`|`false`|`False`|
|`enable_network_policy`|Enable GKE Cluster network policies addon.|`-`|`true`|`False`|
|`enable_only_private_endpoint`|If true, only enable the private endpoint which disable the Public endpoint entirely. If false, private endpoint will be enabled, and the public endpoint will be only accessible by master authorized networks.|`-`|`false`|`False`|
|`enable_sandbox`|Enable GKE Sandbox (Do not forget to set image_type = COS_CONTAINERD and node_version = 1.12.7-gke.17 or later to use it).|`-`|`false`|`False`|
|`enable_shielded_nodes`|Enable GKE Cluster Shielded Nodes features on all nodes.|`-`|`true`|`False`|
|`enable_vertical_pod_autoscaling`|Enable GKE Cluster vertical pod autoscaling addon. Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it.|`-`|`false`|`False`|
|`extra_labels`|Dict of extra labels to add on GCP resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`gcp_project`|The Google Cloud Platform project to use. |`-`|``|`True`|
|`gcp_region`|The Google Cloud Platform region to use.|`-`|`eu-central1`|`False`|
|`gcp_zones`|To use specific Google Cloud Platform zones if not regional, otherwise it will be chosen randomly.|`-`|`[]`|`False`|
|`master_authorized_networks`|List of master authorized networks.|`-`|`[]`|`False`|
|`network_routing_mode`|The network routing mode.|`-`|`GLOBAL`|`False`|
|`node_pools`|GKE Cluster node pools to create.|`-`|`[]`|`False`|
|`pods_cidr`|The CIDR of the pods secondary range.|`-`|`10.9.0.0/16`|`False`|
|`services_cidr`|The CIDR of the services secondary range.|`-`|`10.10.0.0/16`|`False`|
|`subnet_cidr`|The CIDR of the VPC subnet.|`-`|`10.8.0.0/16`|`False`|

**Outputs**

| Name | Description |
|------|-------------|
| `cluster_ca` | GKE Cluster certificate authority. |
| `cluster_endpoint` | GKE Cluster endpoint. |
| `cluster_location` | GKE Cluster location (region if regional cluster, zone if zonal cluster). |
| `cluster_master_authorized_networks_config` | GKE Cluster networks from which access to master is permitted. |
| `cluster_master_version` | GKE Cluster master version. |
| `cluster_name` | GKE Cluster name. |
| `cluster_region` | GKE Cluster region." |
| `cluster_release_channel` | GKE Cluster release channel. |
| `cluster_type` | GKE Cluster type. |
| `cluster_zones` | GKE Cluster zones. |
| `kubeconfig` | Kubernetes config to connect to the GKE cluster. |
| `network_name` | GKE Cluster dedicated network name. |
| `network_self_link` | GKE Cluster dedicated network URI. |
| `node_pools_names` | GKE Cluster node pools names. |
| `node_pools_service_account` | GKE Cluster nodes default service account if not overriden in `node_pools`. |
| `node_pools_versions` | GKE Cluster node pools versions. |
| `pods_ip_range` | GKE Cluster dedicated pods IP range. |
| `services_ip_range` | GKE Cluster dedicated services IP range. |
| `subnet_name` | GKE Cluster dedicated subnet name. |
| `subnet_region` | GKE Cluster dedicated subnet region. |
| `subnet_self_link` | GKE Cluster dedicated subnet URI. |
