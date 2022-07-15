# stack-cycloid-worker

Deploy exactly one Cycloid worker on an instance for Cycloid.io

Create an AWS, Azure or GCP instance and associated networking resources and deploy a Cycloid worker using Cloud-Init.

# Requirements

In order to deploy on Azure, you will need to have a preexisting Resource Group with Azure credentials that are allowed to write resources in this Resource Group.

# Params

## AWS

### Pipeline

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws_cycloid-demo.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws_cycloid-demo.secret_key))`|`True`|
|`config_git_branch`|Branch to use on the config Git repository.|`-`|`($ cr_branch $)`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((git.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`($ cr_url $)`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`cycloid_api_key`|API key to grant admin acess to Cycloid API.|`-`|`((cycloid-api-key.key))`|`True`|
|`cycloid_api_url`|Cycloid API URL.|`-`|`https://http-api.cycloid.io`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`keypair_public`|The public SSH key to provision to bastion for external access through SSH|`-`|`((custom_keypair.ssh_pub))`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the stack Git repository.|`-`|`($ scs_branch $)`|`True`|
|`stack_git_private_key`|SSH key pair to fetch the stack Git repository.|`-`|`((git.ssh_key))`|`True`|
|`stack_git_repository`|Git repository URL containing the stack.|`-`|`($ scs_url $)`|`True`|
|`stack_terraform_path`|Path of Terraform files in the stack git repository|`-`|`stack-cycloid-worker/terraform/aws`|`True`|
|`team_id`|This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field|`-`|`""`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.5'`|`True`|
|`worker_key`|Leave default value if the worker is intended to run for the current organization. Otherwise, add Cycloid-worker-keys.ssh_prv credentials of the target organization|`-`|`((cycloid-worker-keys.ssh_prv))`|`True`|

### Terraform

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`extra_tags`|Dict of extra tags to add on resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`keypair_public`|The public SSH key, for SSH access to newly-created instances|`-`|`""`|`False`|
|`team_id`|This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field.|`-`|`""`|`False`|
|`vm_disk_size`|Disk size for the Cycloid worker (Go)|`-`|`20`|`False`|
|`vm_instance_type`|Instance type for the Cycloid worker|`-`|`'t3.micro'`|`False`|
|`worker_key`|This parameter can be obtained in Cycloid console, by clicking on security/credentials section on the left menu, then look for of a credential named Cycloid-worker-keys, then use the value of the ssh_prv field.|`-`|`""`|`False`|

## Azure

### Pipeline

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`azure_client_id`|Azure client ID to use for Terraform.|`-`|`((azure.client_id))`|`True`|
|`azure_client_secret`|Azure client secret to use for Terraform.|`-`|`((azure.client_secret))`|`True`|
|`azure_env`|Azure environment to use for Terraform. Can be either `public`, `usgovernment`, `german` or `china`.|`-`|`public`|`True`|
|`azure_location`|Azure location to use for terraform. |`-`|`West Europe`|`True`|
|`azure_subscription_id`|Azure subscription ID to use for Terraform.|`-`|`((azure.subscription_id))`|`True`|
|`azure_tenant_id`|Azure tenant ID to use for Terraform.|`-`|`((azure.tenant_id))`|`True`|
|`config_git_branch`|Branch to use on the config Git repository.|`-`|`($ cr_branch $)`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((git.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`($ cr_url $)`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`cycloid_api_key`|API key to grant admin acess to Cycloid API.|`-`|`((cycloid-api-key.key))`|`True`|
|`cycloid_api_url`|Cycloid API URL.|`-`|`https://http-api.cycloid.io`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`keypair_public`|The public SSH key to provision to bastion for external access through SSH|`-`|`((custom_keypair.ssh_pub))`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`rg_name`|Azure Resource Group to use for terraform. |`-`|`"cycloid-worker"`|`True`|
|`stack_git_branch`|Branch to use on the stack Git repository.|`-`|`($ scs_branch $)`|`True`|
|`stack_git_private_key`|SSH key pair to fetch the stack Git repository.|`-`|`((git.ssh_key))`|`True`|
|`stack_git_repository`|Git repository URL containing the stack.|`-`|`($ scs_url $)`|`True`|
|`stack_terraform_path`|Path of Terraform files in the stack git repository|`-`|`stack-cycloid-worker/terraform/azure`|`True`|
|`team_id`|This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field|`-`|`""`|`True`|
|`terraform_resource_group_name`|Azure Resource Group of the Storage Account to use to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform`|`True`|
|`terraform_storage_account_key`|Azure Storage Account key to use to store terraform remote state file.|`-`|`((azure_storage.access_key))`|`True`|
|`terraform_storage_account_name`|Azure Storage Account name to use to store terraform remote state file.|`-`|`((azure_storage.account_name))`|`True`|
|`terraform_storage_container_name`|Azure Storage container name to store terraform remote state file.|`-`|`($ organization_canonical $)`|`True`|
|`terraform_storage_container_path`|Azure Storage container path to store terraform remote state file.|`-`|`($ project $)/($ environment $)`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.5'`|`True`|
|`vm_os_user`|Admin username for newly created instances|`-`|`cycloid`|`True`|
|`worker_key`|Leave default value if the worker is intended to run for the current organization. Otherwise, add Cycloid-worker-keys.ssh_prv credentials of the target organization|`-`|`((cycloid-worker-keys.ssh_prv))`|`True`|

### Terraform

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`azure_location`|Azure location|`-`|`"West Europe"`|`False`|
|`extra_tags`|Dict of extra tags to add on resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`keypair_public`|The public SSH key, for SSH access to newly-created instances|`-`|`""`|`False`|
|`rg_name`|Resource Group name|`-`|`"cycloid-worker"`|`False`|
|`team_id`|This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field.|`-`|`""`|`False`|
|`vm_disk_size`|Disk size for the Cycloid worker (Go)|`-`|`20`|`False`|
|`vm_instance_type`|Instance type for the Cycloid worker|`-`|`'Standard_DS2_v2'`|`False`|
|`vm_os_user`|Admin username for newly created instances|`-`|`cycloid`|`False`|
|`worker_key`|This parameter can be obtained in Cycloid console, by clicking on security/credentials section on the left menu, then look for of a credential named Cycloid-worker-keys, then use the value of the ssh_prv field.|`-`|`""`|`False`|

## GCP

### Pipeline

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch to use on the config Git repository.|`-`|`($ cr_branch $)`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((git.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`($ cr_url $)`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`cycloid_api_key`|API key to grant admin acess to Cycloid API.|`-`|`((cycloid-api-key.key))`|`True`|
|`cycloid_api_url`|Cycloid API URL.|`-`|`https://http-api.cycloid.io`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`gcp_credentials_json`|Google Cloud Platform credentials JSON for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((gcp.json_key))`|`True`|
|`gcp_project`|Google Cloud Platform project to use for Terraform.|`-`|`($ organization_canonical $)`|`True`|
|`gcp_region`|Google Cloud Platform region to use for Terraform.|`-`|`europe-west1`|`True`|
|`keypair_public`|The public SSH key to provision to bastion for external access through SSH|`-`|`((custom_keypair.ssh_pub))`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the stack Git repository.|`-`|`($ scs_branch $)`|`True`|
|`stack_git_private_key`|SSH key pair to fetch the stack Git repository.|`-`|`((git.ssh_key))`|`True`|
|`stack_git_repository`|Git repository URL containing the stack.|`-`|`($ scs_url $)`|`True`|
|`stack_terraform_path`|Path of Terraform files in the stack git repository|`-`|`stack-cycloid-worker/terraform/gcp`|`True`|
|`team_id`|This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field|`-`|`""`|`True`|
|`terraform_storage_bucket_name`|Google Cloud Storage bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.5'`|`True`|
|`vm_os_user`|Admin username for newly created instances|`-`|`admin`|`True`|
|`worker_key`|Leave default value if the worker is intended to run for the current organization. Otherwise, add Cycloid-worker-keys.ssh_prv credentials of the target organization|`-`|`((cycloid-worker-keys.ssh_prv))`|`True`|

### Terraform

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`extra_tags`|Dict of extra tags to add on resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`keypair_public`|The public SSH key, for SSH access to newly-created instances|`-`|`""`|`False`|
|`team_id`|This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field.|`-`|`""`|`False`|
|`vm_disk_size`|Disk size for the Cycloid worker (Go)|`-`|`20`|`False`|
|`vm_machine_type`|Machine type for the instance|`-`|`'n2-standard-2'`|`False`|
|`vm_os_user`|Admin username for newly created instances|`-`|`admin`|`False`|
|`worker_key`|This parameter can be obtained in Cycloid console, by clicking on security/credentials section on the left menu, then look for of a credential named Cycloid-worker-keys, then use the value of the ssh_prv field.|`-`|`""`|`False`|

