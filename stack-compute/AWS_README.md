# Stack-compute - AWS

Deploys a configurable EC2 instance in AWS and a correspondent security group in a designated VPC, pre-configured with an SSH allow traffic rule.

# Requirements

In order to run this task, couple elements are required :

  * Having a VPC with private & public subnets [Here](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html#getting-started-create-vpc)
  * Having an S3 bucket to store Terraform remote states [Here](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html)

# Details

## Pipeline - Params

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ .project $)/terraform/($ .environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ .organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ .environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ .project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ .organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'1.0.6'`|`True`|


## Terraform - inputs

**AMI Configurations**
|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`ami_architecture`|The AMI image architecture.|`string`|``|`False`|
|`ami_most_recent`|If more than one result is returned, use the most recent AMI|`bool`|``|`False`|
|`ami_name`|The name of the AMI.|`string`|``|`True`|
|`ami_owners`|List of AMI owners to limit search.|`string`|``|`True`|
|`ami_root_device_type`|The AMI type of the root device volume.|`string`|``|`False`|
|`ami_virtualisation_type`|The AMI virtualization type.|`string`|``|`False`|


**Instance General Configurations**
Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`instance_type`|The instance type to use for the instance. "|`string`|``|`True`|
|`file_content`|The content of the file to use if cloud init is used.|`string`|``|`False`|
|`key_name`|Key name of the Key Pair to use for the instance.|`string`|``|`False`|
|`instance_extra_tags`|A map of tags to assign to the resource.|`-`|``|`False`|

**Network Configurations**
Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`subnet_id`|VPC Subnet ID to launch in.|`string`|``|`True`|
|`private_ip`|Private IP address to associate with the instance in a VPC.|`string`|``|`False`|
|`associate_public_ip_address`|Whether to associate a public IP address with an instance in a VPC.|`boolean`|``|`False`|


**Volume Configurations**
Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`enable_vm_disk_delete_on_termination`|Whether the volume should be destroyed on instance termination.|`boolean`|``|`False`|
|`enable_vm_disk_encrypted`|Whether to enable volume encryption.|`boolean`|``|`False`|
|`vm_disk_size`|Size of the root volume in gibibytes (GiB).|`integer`|``|`False`|
|`vm_disk_type`|Type of the root volume.|`string`|``|`False`|
|`ebs_optimized`|If true, the launched EC2 instance will be EBS-optimized.|`bool`|``|`False`|
|`volume_extra_tags`|A map of tags to assign, at instance-creation time, to root and EBS volumes.|`-`|``|`False`|

**Security Group Configurations**
Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`sg_name`|Name of the security group.|`string`|``|`False`|
|`vpc_id`|VPC ID used to create the security group.|`string`|``|`True`|
|`sg_egress_rules`|Configuration block for egress rules.|`array`|``|`False`|
|`sg_extra_tags`|Map of extra tags to assign to the security group.|`-`|``|`False`|
|`sg_ingress_rules`|Configuration block for ingress rules.|`array`|``|`False`|

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP of the VM |


## Attach extra storage to the VM

If you need to attach extra storage to the VM, you'll need to create and add the terraform code in a separate file. Please follow the example as defined in the end of the file [vm.tf.sample](terraform/aws/vm.tf.sample)