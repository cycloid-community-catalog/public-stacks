# Stack-compute - AZURE

Deploys a configurable linux vm in azure, configured with a NIC associated with a public address and a security group, pre-configured with an SSH allow traffic rule.

# Requirements

In order to run this task, couple elements are required :

  * Having an Azure Storage Account to store Terraform remote states [Here](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json&tabs=azure-portal)
  * Having a Resource Group to associate to the project [Here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
  * Having a virtual network configured where the Network Interface should be localted at [Here](https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-portal)

# Details

## Pipeline - Params
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`azure_client_id`|Azure client ID to use for Terraform.|`-`|`((azure_admin.client_id))`|`True`|
|`azure_client_secret`|Azure client secret to use for Terraform.|`-`|`((azure_admin.client_secret))`|`True`|
|`azure_env`|Azure environment to use for Terraform. Can be either `public`, `usgovernment`, `german` or `china`.|`-`|`public`|`True`|
|`azure_location`|Azure location to use for terraform. |`-`|`West Europe`|`True`|
|`azure_subscription_id`|Azure subscription ID to use for Terraform.|`-`|`((azure_admin.subscription_id))`|`True`|
|`azure_tenant_id`|Azure tenant ID to use for Terraform.|`-`|`((azure_admin.tenant_id))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-aks.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ .project $)/terraform/($ .environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ .organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ .environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ .project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_resource_group_name`|Azure Resource Group of the Storage Account to use to store terraform remote state file.|`-`|`($ .organization_canonical $)-terraform`|`True`|
|`terraform_storage_account_key`|Azure Storage Account key to use to store terraform remote state file.|`-`|`((azure_storage_aks.access_key))`|`True`|
|`terraform_storage_account_name`|Azure Storage Account name to use to store terraform remote state file.|`-`|`((azure_storage_aks.account_name))`|`True`|
|`terraform_storage_container_name`|Azure Storage container name to store terraform remote state file.|`-`|`($ .organization_canonical $)`|`True`|
|`terraform_storage_container_path`|Azure Storage container path to store terraform remote state file.|`-`|`($ .project $)/($ .environment $)`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.6'`|`True`|

## Terraform - inputs

**OS image Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`image_id`|Specifies the ID of the Custom Image which the Virtual Machine should be created from|`string`|``|`False`|
|`image_offer`|Specifies the offer of the image used to create the virtual machine.|`string`|``|`True`|
|`image_publisher`|Specifies the publisher of the image used to create the virtual machine.|`string`|``|`True`|
|`image_sku`|Specifies the SKU of the image used to create the virtual machine.|`string`|``|`True`|
|`image_version`|Specifies the version of the image used to create the virtual machine.|`string`|``|`False`|

**Instance Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`instance_name`|Specifies the name of the Virtual Machine.|`string`|``|`False`|
|`resource_group_name`|The name of the resource group to use for the creation of resources.|`string`|``|`True`|
|`vm_size`|Specifies the size of the Virtual Machine.|`string`|``|`True`|
|`file_content`|The content of the file to use if cloud init is used.|`string`|``|`False`|
|`os_admin_password`|The password associated with the local admin account. Must be [6-72] and contain uppercase + lowercase + number + special caracter|`string`|``|`True`|
|`os_admin_username`|Specifies the name of the local admin account.|`string`|``|`True`|
|`os_computer_name`|Specifies the name of the Virtual Machine.|`string`|``|`True`|
|`disable_linux_password_authentification`|Specifies whether password authentication should be disabled.|`boolean`|``|`True`|
|`instance_extra_tags`|A map of tags to assign to the resource.|`-`|``|`False`|

**Network Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`network_interface_name`|The name of the Network Interface.|`string`|``|`False`|
|`public_ip_name`|Specifies the name of the Public IP resource.|`string`|``|`False`|
|`ip_config_name`|A name used for the IP Configuration in the network interface.|`string`|``|`False`|
|`subnet_id`|The ID of the Subnet where this Network Interface should be located in.|`string`|``|`False`|
|`network_extra_tags`|Map of extra tags to assign to the network resources.|`-`|``|`False`|


**OS Disk Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`disk_name`|Specifies the name of the OS Disk.|`string`|``|`False`|
|`disk_size`|Specifies the name of the OS Disk size in gigabytes.|`string`|``|`False`|
|`disk_managed_type`|Specifies the type of Managed Disk which should be created.|`string`|``|`False`|
|`delete_os_disk_on_termination`|Enables deleting the OS disk automatically when deleting the VM.|`boolean`|``|`True`|

**Security Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`network_security_group_name`|Specifies the name of the Application Security Group.|`string`|``|`False`|
|`security_rule_access`|Specifies whether network traffic is allowed or denied by default rule.|`string`|``|`True`|
|`security_rule_description`|A description of the default rule.|`string`|``|`False`|
|`security_rule_destination_address_prefix`|"Lists of destination address prefixes to match in the default rule."|`string`|``|`True`|
|`security_rule_destination_port_range`|"Default rule destination port or range."|`string`|``|`True`|
|`security_rule_direction`|Specifies if default rule will be evaluated on incoming or outgoing traffic.|`string`|``|`True`|
|`security_rule_name`|The name of the default security rule.|`string`|``|`True`|
|`security_rule_priority`|Specifies the priority of the default rule.|`integer`|``|`True`|
|`security_rule_protocol`|Network protocol that default rule applies to.|`string`|``|`True`|
|`security_rule_source_address_prefix`|"Default rule, CIDR or source IP range or * to match any IP."|`string`|``|`True`|
|`security_rule_source_port_range`|Default rule source port or range.|`string`|``|`True`|
|`sg_extra_tags`|Map of extra tags to assign to the security group.|`-`|``|`False`|

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP of the VM |


## Attach extra storage to the VM or more network security rules

If you need to attach extra storage to the VM or more network security rules, you'll need to create and add the terraform code in a separate file. Please follow the example as defined in the end of the file [vm.tf.sample](terraform/azure/vm.tf.sample)
