# Stack-hello-world

Service catalog hello world stack.

This stack will create a small pipeline and infrastructure on your Cloud provider.

# Examples

**AWS**
  * **Lambda**: [Amazon Lambda](docs/AWS.md)

**GCP**
  * **Cloud function** [Google Cloud Function](docs/GCP.md)


# Details

## AWS pipeline

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((git_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-git.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`release_bucket_object_path`|AWS S3 bucket path to store release of the code. This will be in the same bucket as the tfstate Terraform file.|`-`|`($ project $)/($ environment $)`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|

## GCP pipeline

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((git_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-git.git`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`gcp_credentials`|GCP json credentials for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline).|`-`|`((gcp_credentials.json))`|`True`|
|`gcp_default_region`|GCP region to use for Terraform.|`-`|`europe-west1`|`True`|
|`gcp_project`|GCP project to use for Terraform.|`-`|`hello-world`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`release_bucket_object_path`|GCP GCS bucket path to store release of the code. This will be in the same bucket as the tfstate Terraform file.|`-`|`($ project $)/($ environment $)/($ project $).zip`|`True`|
|`terraform_storage_bucket_name`|GCP GCS bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_storage_bucket_path`|GCP GCS bucket path to store terraform remote state file.|`-`|`($ project $)/($ environment $)`|`True`|
