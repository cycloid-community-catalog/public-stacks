# Stack-ses

Service catalog Simple Email Service stack

This stack will create an SES iam user and a SQS queue if needed to manage bounced emails.

# Architecture

<p align="center">
<img src="docs/diagram.png" width="400">
</p>


  * **SES**: Amazon Simple Email Service
  * **IAM** Amazon Identity and Access Management
  * **Elasticache** Amazon ElastiCache
  * **SNS** Amazon Simple Notification Service

# Requirements

In order to run this task, couple elements are required within the infrastructure:

  * Having a VPC with private & public subnets [here](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html#getting-started-create-vpc)
  * Having an S3 bucket with versioning to store Terraform remote states [here](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html)

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
|`aws_access_key`|Amazon AWS access key for Terraform. see value format [Here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. see value format [Here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`config_git_branch`|Branch of the config git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository url containing the config of the stack.|`-`|`git@github.com:MyUser/config-ses.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_storage_bucket_path`|AWS S3 bucket path to store terraform remote state file.|`-`|`($ project $)/($ environment $)`|`True`|

## Terraform

**Inputs**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_region`|Name of the region where the infrastructure is created|`-`|`us-east-1`|`False`|
|`create_elasitcache`|If you need to create an elasticache (for example used for sending/queing emails)|`bool`|`false`|`False`|
|`create_sqs`|If you need to create a sqs (for example used for bounce emails)|`bool`|`false`|`False`|
|`elasticache_security_groups`|Those security groups will be granted access to the elasticache cluster|`list`|`[]`|`False`|
|`elasticache_subnet_group_name`|Name of an Amazon elasticache subnet group to use|`-`|`redis`|`False`|
|`elasticache_type`|Instance type to use for the elasticache cluster|`-`|`cache.t2.micro`|`False`|
|`extra_tags`|Dict of extra tags to add on aws resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`mail_domain`|Domain used for emailing|`-`|``|`True`|
|`vpc_id`|Amazon VPC id on which create each components.|`-`|``|`True`|


**Outputs**

| Name | Description |
|------|-------------|
| aws_sqs_queue_url | sqs |
| elasticache_endpoint | elsticache |
| iam_ses_key | SES iam |
| iam_ses_secret | Dedicated IAM secret key for SES |
| iam_ses_smtp_user_key | Dedicated SES SMTP key |
| iam_ses_smtp_user_secret | Dedicated SES SMTP secret |

