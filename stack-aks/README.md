# stack-aks

This stack will create a Azure Kubernetes Service cluster with it's own dedicated network and one or more node pools.

  * Azure Virtual Network
  * Azure Kubernetes Service

# Architecture

<p align="center">
<img src="docs/diagram.png" width="400">
</p>


  * **VNet**: Azure Virtual Network
  * **AKS**: Azure Kubernetes Service
  * **NP**: Azure Kubernetes Node Pools

# Requirements

In order to run this task, couple elements are required within the infrastructure:

  * Having an Azure Storage Account to store Terraform remote states [Here](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal)


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

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aks_service_principal_client_id`|The Client ID for the Service Principal used by the AKS cluster.|`-`|`((custom_($ project $)-($ environment $)-sp.client_id))`|`True`|
|`aks_service_principal_client_secret`|The Client Secret for the Service Principal used by the AKS cluster.|`-`|`((custom_($ project $)-($ environment $)-sp.client_secret))`|`True`|
|`azure_client_id`|Azure client ID to use for Terraform.|`-`|`((azure_admin.client_id))`|`True`|
|`azure_client_secret`|Azure client secret to use for Terraform.|`-`|`((azure_admin.client_secret))`|`True`|
|`azure_env`|Azure environment to use for Terraform. Can be either `public`, `usgovernment`, `german` or `china`.|`-`|`public`|`True`|
|`azure_location`|Azure location to use for terraform. |`-`|`West Europe`|`True`|
|`azure_subscription_id`|Azure subscription ID to use for Terraform.|`-`|`((azure_admin.subscription_id))`|`True`|
|`azure_tenant_id`|Azure tenant ID to use for Terraform.|`-`|`((azure_admin.tenant_id))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-aks.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_resource_group_name`|Azure Resource Group of the Storage Account to use to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform`|`True`|
|`terraform_storage_account_key`|Azure Storage Account key to use to store terraform remote state file.|`-`|`((azure_storage_aks.account_key))`|`True`|
|`terraform_storage_account_name`|Azure Storage Account name to use to store terraform remote state file.|`-`|`((azure_storage_aks.account_name))`|`True`|
|`terraform_storage_container_name`|Azure Storage container name to store terraform remote state file.|`-`|`($ organization_canonical $)`|`True`|
|`terraform_storage_container_path`|Azure Storage container path to store terraform remote state file.|`-`|`($ project $)/($ environment $)`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'0.12.21'`|`True`|


## Terraform

**Inputs**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`address_space`|The virtual network address space.|`-`|`10.8.0.0/16`|`False`|
|`cluster_allowed_ips`|Allow Inbound IP CIDRs to access the Kubernetes API.|`-`|`[]`|`False`|
|`cluster_version`|AKS Cluster version to use, defaults to the latest recommended but no auto-upgrade.|`-`|`null`|`False`|
|`enable_kube_dashboard`|Should be `true` to enable the Kubernetes Dashboard.|`-`|`false`|`False`|
|`enable_oms_agent`|Should be `true` to enable OMS agent for log analytics.|`-`|`true`|`False`|
|`enable_pod_security_policy`|Should be `true` to enable Pod Security Policies. Pod Security Policies needs to be enabled via the Azure CLI. @see https://github.com/Azure/AKS/blob/master/previews.md#kubernetes-pod-security-policies-|`-`|`false`|`False`|
|`enable_rbac`|Should be `true` to enable Role Based Access Control.|`-`|`true`|`False`|
|`extra_tags`|Dict of extra tags to add on aws resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`log_analytics_workspace_sku`|The Log Analytics workspace SKU to use if `enable_oms_agent = true`.|`-`|`PerGB2018`|`False`|
|`log_retention_in_days`|The Log Analytics retention in days to use if `enable_oms_agent = true`.|`-`|`30`|`False`|
|`network_docker_bridge_cidr`|AKS cluster service CIDR to use, required if `network_plugin = azure`.|`-`|`172.17.0.1/16`|`False`|
|`network_load_balancer_sku`|AKS cluster load balancer SKU, can be either `basic` or `standard`.|`-`|`basic`|`False`|
|`network_plugin`|AKS cluster network plugin to use, can be either `azure` or `kubenet`.|`-`|`azure`|`False`|
|`network_pod_cidr`|AKS cluster pod CIDR to use, required if `network_plugin = kubenet`.|`-`|`10.9.0.0/16`|`False`|
|`network_policy_plugin`|AKS cluster network policy plugin to use, can be either `azure` or `calico`. `azure` only available with `network_plugin = azure`.|`-`|`azure`|`False`|
|`network_service_cidr`|AKS cluster service CIDR to use, required if `network_plugin = azure`.|`-`|`10.10.0.0/16`|`False`|
|`node_admin_username`|AKS node admin username for SSH connection.|`-`|`cycloid`|`False`|
|`node_availability_zones`|To use specific Azure Availability Zones for the default nodes pool. @see https://docs.microsoft.com/en-us/azure/availability-zones/az-overview|`-`|`[]`|`False`|
|`node_count`|AKS default nodes desired count.|`-`|`1`|`False`|
|`node_disk_size`|AKS default nodes root disk size.|`-`|`60`|`False`|
|`node_enable_auto_scaling`|Enable auto scaling of AKS default nodes.|`-`|`true`|`False`|
|`node_enable_public_ip`|Should be true if public IPs should be associated to AKS default nodes.|`-`|`false`|`False`|
|`node_max_count`|AKS default nodes auto scaling group maximum count.|`-`|`10`|`False`|
|`node_max_pods`|Maximum number of pods per AKS default node (can't be more than 250).|`-`|`250`|`False`|
|`node_min_count`|AKS default nodes auto scaling minimum count.|`-`|`1`|`False`|
|`node_network_subnet_id`|Network subnet ID that should be used by AKS default nodes.|`-`|``|`True`|
|`node_pool_name`|AKS default nodes pool given name.|`-`|`default`|`False`|
|`node_pool_type`|AKS default nodes pool type, can be either `AvailabilitySet` or `VirtualMachineScaleSets`.|`-`|`Linux`|`False`|
|`node_size`|AKS default nodes virtualmachine size.|`-`|`Standard_DS2_v2`|`False`|
|`node_ssh_key`|AKS node admin SSH key for SSH connection.|`-`|`""`|`False`|
|`node_taints`|AKS nodes taints to setup.|`-`|`[]`|`False`|
|`rbac_client_app_id`|The Client ID of an Azure Active Directory Application for Role Based Access Control.|`-`|`""`|`False`|
|`rbac_client_app_secret`|The Server Secret of an Azure Active Directory Application for Role Based Access Control.|`-`|`""`|`False`|
|`rbac_server_app_id`|The Server ID of an Azure Active Directory Application for Role Based Access Control.|`-`|`""`|`False`|
|`rbac_use_active_directory`|Should be `true` to enable Role Based Access Control with an Azure Active Directory.|`-`|`false`|`False`|
|`ssh_allowed_ips`|Allow Inbound IP CIDRs to access the instances via SSH.|`-`|`["*"]`|`False`|
|`subnets`|The private subnets for the VPC.|`list`|`{"nodes" = "10.8.0.0/16", "pods"  = "10.9.0.0/16", "loadbalancers" = "10.11.0.0/16",}`|`False`|

**Outputs**

| Name | Description |
|------|-------------|
| `vnet_id` | AKS Cluster dedicated vNet ID. |
| `vnet_name` | AKS Cluster dedicated vNet name. |
| `vnet_location` | AKS Cluster dedicated vNet location. |
| `vnet_subnet_ids` | AKS Cluster dedicated vNet subnet IDs. |
| `vnet_address_space` | AKS Cluster dedicated vNet address space. |
| `nodes_sg_allow` | AKS Cluster dedicated vNet security group to allow SSH and metrics access to instances. |
| `cluster_id` | AKS Cluster ID. |
| `cluster_public_fqdn` | AKS Cluster public FQDN. |
| `cluster_private_fqdn` | AKS Cluster private FQDN. |
| `control_plane_host` | AKS Cluster kubeconfig host. |
| `control_plane_ca` | AKS Cluster certificate authority. |
| `kubeconfig` | Kubernetes config to connect to the AKS Cluster. |

