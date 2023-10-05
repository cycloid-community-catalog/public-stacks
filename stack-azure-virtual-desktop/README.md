# stack-azure-virtual-desktop

This Stack deploys an ARM Azure Virtual Desktop encironment (non AVD Classic).

# Requirements

You will need the following to run this Stack :

  - an existing resource group where the Azure Virtual Desktop environment will be deployed. Please make sure the Resource Group location supports AVD Host Pools if it is needed.
  - an Azure subscription ID, tenant ID, client ID, client secret having write access to the above Resource Group to deploy the AVD environment.
  - an Azure Storage Account and an Azure Storage container to store your Terraform remote state file. To connect, you will need the Azure Storage Account name and its access key. You will also need the Azure Resource Group of the Storage Account.
  - A Cycloid API key allowing to post Cycloid events from the pipeline.

# Use cases

There is a single default use case in this stack.

# Params

## Pipeline Params
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`azure_client_id`|Azure client ID to use for Terraform.|`-`|`((azure.client_id))`|`True`|
|`azure_client_secret`|Azure client secret to use for Terraform.|`-`|`((azure.client_secret))`|`True`|
|`azure_env`|Azure environment to use for Terraform. Can be either `public`, `usgovernment`, `german` or `china`.|`-`|`public`|`True`|
|`azure_subscription_id`|Azure subscription ID to use for Terraform.|`-`|`((azure.subscription_id))`|`True`|
|`azure_tenant_id`|Azure tenant ID to use for Terraform.|`-`|`((azure.tenant_id))`|`True`|
|`config_git_branch`|Branch to use on the config Git repository.|`-`|`config`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((git.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:cycloidio/cycloid-stacks-test.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`cycloid_api_key`|API key to grant admin acess to Cycloid API.|`-`|`((cycloid-api-key.key))`|`True`|
|`cycloid_api_url`|Cycloid API URL.|`-`|`https://http-api.cycloid.io`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the stack Git repository.|`-`|`master`|`True`|
|`stack_git_private_key`|SSH key pair to fetch the stack Git repository.|`-`|`((git.ssh_key))`|`True`|
|`stack_git_repository`|Git repository URL containing the stack.|`-`|`git@github.com:cycloidio/cycloid-demo-stacks.git`|`True`|
|`stack_terraform_path`|Path of Terraform files in the stack git repository|`-`|`stack-azure-virtual-desktop/terraform`|`True`|
|`terraform_resource_group_name`|Azure Resource Group of the Storage Account to use to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform`|`True`|
|`terraform_storage_account_key`|Azure Storage Account key to use to store terraform remote state file.|`-`|`((azure_storage.access_key))`|`True`|
|`terraform_storage_account_name`|Azure Storage Account name to use to store terraform remote state file.|`-`|`((azure_storage.account_name))`|`True`|
|`terraform_storage_container_name`|Azure Storage container name to store terraform remote state file.|`-`|`($ organization_canonical $)`|`True`|
|`terraform_storage_container_path`|Azure Storage container path to store terraform remote state file.|`-`|`($ project $)/($ environment $)`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.5'`|`True`|

## Terraform Params
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`app_group_type`|The type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups|`-`|`'Desktop'`|`False`|
|`extra_tags`|Dict of extra tags to add on resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`host_pool_expiration_date`|A valid RFC3339Time for the expiration of the token (between 1 hour and 30 days from now). For example: 2022-01-01T23:40:52Z|`-`|`''`|`False`|
|`host_pool_lb_type`|TBreadthFirst load balancing distributes new user sessions across all available session hosts in the host pool. DepthFirst load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold|`-`|`'DepthFirst'`|`False`|
|`host_pool_max_sessions`|Maximum number of users that have concurrent sessions on a session host. Should only be set if the type of your Virtual Desktop Host Pool is Pooled|`-`|`16`|`False`|
|`host_pool_type`|The type of the Virtual Desktop Host Pool. Valid options are Personal or Pooled. Changing the type forces a new resource to be created|`-`|`'Personal'`|`False`|
|`rg_name`|The name of the existing resource group where the resources will be deployed|`-`|`'cycloid-get-started'`|`False`|