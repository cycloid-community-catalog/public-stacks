# stack-lemp (Linux, NGINX, MySQL, PHP)

This stack will create A full LEMP infrastructure based on ASG and RDS database.

  * Linux operating system
  * NGINX (Pronounced as Engine-X) web server
  * MySQL (RDS) database server
  * PHP-FPM for dynamic data processing

# Architecture

<p align="center">
<img src="docs/diagram.png" width="400">
</p>


  * **ALB**: Amazon Application Load Balancer
  * **ASG**: Amazon Auto Scaling group for fronts
  * **front**: EC2 instances from builded AMI
  * **RDS** (optional): Amazon RDS database (mysql)
  * **ElastiCache** (optional): Amazon ElastiCache (Redis)
  * **S3 bucket** (optional): public medias bucket

# Requirements

In order to run this task, couple elements are required within the infrastructure:

  * Having a VPC with private & public subnets [Here](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html#getting-started-create-vpc)
  * Having a bastion server to run Ansible like described [Here](https://docs.cycloid.io/advanced-guide/ansible-integration.html#standard-usage)
  * Having an S3 bucket to store Terraform remote states [Here](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html)
  * Having an S3 bucket for website code **WITH** versioning enable [Here](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html)


# Details

## Pipeline

> **Note** The pipeline contains a manual approval between terraform plan and terraform apply.
> That means if you trigger a terraform plan, to apply it, you have to go on terraform apply job
> and click on the `+` button to trigger it.

<img src="docs/pipeline.png" width="800">

**Jobs description**

  * `build-ami-front` : Build Front Amazon image AMI using Packer and Ansible.
  * `build-application`: Runs the appropriate php/composer commands and build a release file of the code to put it on S3.
  * `terraform-plan`: Terraform job that will simply make a plan of the stack.
  * `terraform-apply`: Terraform job similar to the plan one, but will actually create/update everything that needs to. Please see the plan diff for a better understanding.
  * `unittests`: Dummy job meant to eventually be replaced by proper tests or removed.
  * `application-deployment`: Simply trigger a deployment using Ansible of the last version of the code on existing instances.
  * `functional-tests`: Dummy job meant to eventually be replaced by proper functional or removed.
  * `terraform-destroy`: :warning: Terraform job meant to destroy the whole stack - **NO CONFIRMATION ASKED**. If triggered, the full project **WILL** be destroyed. Use with caution.

**Params**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`ansible_vault_password`|Password used by ansible vault to decrypt your vaulted files.|`-`|`((custom_ansible_vault_password))`|`False`|
|`ansible_version`|Ansible version used in packer and cycloid-toolkit ansible runner|`-`|`"2.9"`|`True`|
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`bastion_private_key_pair`|bastion SSH private key used by ansible to connect on AWS EC2 instances and the bastion itself.|`-`|`((ssh_bastion.ssh_key))`|`True`|
|`bastion_url`|bastion URL used by ansible to connect on AWS EC2 instances.|`-`|`user@bastion.server.com`|`True`|
|`config_ansible_path`|Path of Ansible files in the config Git repository|`-`|`($ project $)/ansible`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config-lemp-app.git`|`True`|
|`config_pipeline_path`|Path of pipeline task yml files in the config Git repository. Used to override pipeline yask like build-release.yml|`-`|`($ project $)/pipeline`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`cycloid_toolkit_tag_prefix`|Prefix used with ansible_version to match cycloid-toolkit docker image tag. (example with "a": cycloid/cycloid-toolkit:a2.9).|`-`|`"a"`|`True`|
|`debug_public_key`|SSH pubkey injected by packer during the ec2 ami build. Used only to debug failure.|`-`|`""`|`False`|
|`deploy_bucket_name`|AWS S3 bucket name in which store the builded code of the website.|`-`|`($ project $)-deploy`|`True`|
|`deploy_bucket_object_path`|AWS S3 bucket path in which store the builded code of the website.|`-`|`/catalog-lemp-app/($ environment $)/lemp-app.tar.gz`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`lemp_git_branch`|Branch of the LEMP source code Git repository.|`-`|`master`|`True`|
|`lemp_git_private_key`|SSH key pair to fetch LEMP source code Git repository.|`-`|`((ssh_lemp_app.ssh_key))`|`True`|
|`lemp_git_repository`|URL to the Git repository containing LEMP website source code.|`-`|`git@github.com:MyUser/code-lemp.git`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`rds_password`|Password used for your rds. Set "empty" if you dont use databases|`-`|`((custom_rds_password))`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.1'`|`True`|

## Terraform

**Inputs**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`application_ssl_cert`|ARN of an Amazon cert (ACM) to use for the loadbalancer.|`-`|``|`False`|
|`bastion_sg_allow`|Amazon source security group ID which will be allowed to connect on Fronts port 22 (SSH).|`-`|``|`False`|
|`cache_subnet_group`|Name of the Amazon ElastiCache subnet group to use. If not specified, create a dedicated group with private_subnets_ids.|`-`|``|`False`|
|`cloudfront_aliases`|Extra cname for the cloudfront distribution.|`list`|`[]`|`False`|
|`cloudfront_ssl_certificate`|ACM certificate arn to use for cloudfront domain. Need to be in us-east-1 region.|`string`|`"arn:aws:acm:us-east-1:xxxxxxxx:certificate/xxxxxxx"`|`False`|
|`create_cloudfront_medias`|Create a Cloudfront on top of medias S3 bucket.|`bool`|`false`|`False`|
|`create_elasticache`||`bool`|`true`|`False`|
|`create_rds`|Define if we want to create or not an RDS database.|`bool`|`false`|`False`|
|`create_s3_medias`|Create a S3 bucket dedicated to medias for the LEMP application.|`bool`|`false`|`False`|
|`create_ses_access`|Create a iam user and instance profile to use AWS SES.|`bool`|`false`|`False`|
|`elasticache_engine`|Type of the ElastiCache engine.|`-`|`redis`|`False`|
|`elasticache_engine_version`|Version of the ElastiCache engine.|`-`|`5.0.6`|`False`|
|`elasticache_nodes`|Number of nodes in the ElastiCache cluster.|`-`|`1`|`False`|
|`elasticache_parameter_group_name`|ElastiCache group parameter name to use.|`-`|`default.redis5.0`|`False`|
|`elasticache_port`|Port of the ElastiCache.|`-`|`6379`|`False`|
|`elasticache_type`|Instance size to use for ElastiCache nodes.|`-`|`cache.t2.micro`|`False`|
|`extra_tags`|Dict of extra tags to add on aws resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`front_asg_max_size`|Maximum number of front server allowed in the AutoScaling group.|`-`|`5`|`False`|
|`front_count`|Desired number of front servers.|`-`|`1`|`False`|
|`front_disk_size`|Disk size of front servers.|`-`|`30`|`False`|
|`front_ebs_optimized`|Whether the Instance is EBS optimized or not, related to the instance type you choose.|`bool`|`false`|`False`|
|`front_type`|Type of instance to use for front servers.|`-`|`t3.small`|`False`|
|`keypair_name`|Name of an existing AWS SSH keypair to use to deploy EC2 instances.|`-`|`cycloid`|`False`|
|`metrics_sg_allow`|Additionnal security group ID to assign to servers. Goal is to allow monitoring server to query metrics.|`-`|`""`|`False`|
|`private_subnets_ids`|Amazon subnets IDs on which create each components.|`array`|``|`True`|
|`public_subnets_ids`|Amazon subnets IDs on which create each components.|`array`|``|`True`|
|`rds_backup_retention`|The days to retain backups for. Must be between 0 and 35. When creating a Read Replica the value must be greater than 0.|`-`|`7`|`False`|
|`rds_database`|RDS database name.|`-`|`application`|`False`|
|`rds_disk_size`|RDS disk size.|`-`|`10`|`False`|
|`rds_engine`|RDS database engine to use.|`-`|`mysql`|`False`|
|`rds_engine_version`|The version of the RDS database engine.|`-`|`5.7.16`|`False`|
|`rds_extra_sg_allow`|Amazon source security group ID which will be allowed to connect on rds.|`-`|``|`False`|
|`rds_multiaz`|If the RDS instance is multi AZ enabled.|`bool`|`false`|`False`|
|`rds_parameters`|Name of the RDS parameters group to use.|`-`|`default.mysql5.7`|`False`|
|`rds_password`|RDS password. expected value is "${var.rds_password}" to get it from the pipeline.|`-`|`ChangeMePls`|`False`|
|`rds_subnet_group`|RDS subnet group name to use. If not specified, create a dedicated group with private_subnets_ids.|`-`|``|`False`|
|`rds_type`|RDS database instance size.|`-`|`db.t3.small`|`False`|
|`rds_username`|RDS database username.|`-`|`application`|`False`|
|`s3_medias_acl`|Set the default acl of the medias S3 bucket.|`string`|`"public-read"`|`False`|
|`s3_medias_policy_json`|Override the default json policy applied to the bucket.|`string`|`data.aws_iam_policy_document.public_s3_bucket_medias[0].json`|`False`|
|`ses_resource_arn`|Define a arn to limitate SES access.|`string`|`"*"`|`False`|
|`vpc_id`|Amazon VPC id on which create each components.|`-`|``|`True`|

**Outputs**

| Name | Description |
|------|-------------|
| alb_front_dns_name | DNS name of the front ALB. |
| alb_front_zone_id | Zone ID of the front ALB. |
| elasticache_address | Address of the ElastiCache. |
| elasticache_cluster_id | Cluster Id of the ElastiCache. |
| rds_address | Address of the RDS database. |
| rds_port | Port of the RDS database. |
| rds_username | Username of the RDS database. |
| rds_database | Database name of the RDS database. |
| iam_s3-medias_user_key | Access key of the dedicated IAM user to access to the media S3 bucket. |
| iam_s3-medias_user_secret | Access secret key of the dedicated IAM user to access to the media S3 bucket. |
| iam_s3-medias_user_name | Iam user name of the dedicated IAM user to access to the media S3 bucket. |
| s3_medias | S3 bucket name dedicated to medias. |
| iam_ses_user_key | Iam user key for SES. |
| iam_ses_user_secret | Iam user secret for SES. |
| iam_ses_smtp_user_key | Smtp user key for ses. |
| iam_ses_smtp_user_secret | Smtp user secret for ses. |
| cloudfront_medias_domain_name | Cloudfront domain on top of S3 medias bucket. |


## Ansible

  * Playbook and packer config to build a debian image with telegraf, fluentd, nginx and php-fpm installed

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`cycloid_files_watched`|Provide log files you want to export to Cycloid logs.|`-`|`<Default log files watched>`|`False`|
|`nginx_sites`|Contain Nginx vhosts to create on front servers. A default application and metrics vhosts are already provided.|`dict`|`<metric and application vhost>`|`False`|
|`nginx_vhost_extra_directive`|If you need extra directive to add in the default application vhost. Example basic auth, https redirect ...|`dict`|``|`False`|
|`php_version_to_install`|PHP fpm version to install.|`-`|`7.2`|`False`|
|`telegraf_install`|Install telegraf|`bool`|`true`|`False`|

# Molecule tests

Requires a bucket which contains a build of magento sources and AWS access key

virtualenv if needed
```
virtualenv    .env  --clear
source .env/bin/activate

pip install ansible==2.7 molecule==3.0a4 docker-py
```

Run the test
```
cd ansible

export AWS_ACCESS_KEY_ID=AKI...
export AWS_SECRET_ACCESS_KEY=....

export DEPLOY_BUCKET_NAME=cycloid-deploy
export DEPLOY_BUCKET_OBJECT_PATH=catalog-lemp-app/ci/lemp-app.tar.gz
export DEPLOY_BUCKET_REGION=eu-west-1

# Run molecule
molecule destroy
molecule converge
molecule verify
```
