# stack-eks

This stack will create a Amazon Elastic Kubernetes Service cluster with it's own dedicated VPC and one or more node groups.

  * Amazon Amazon Virtual Private Cloud
  * Amazon Elastic Kubernetes Service
  * Amazon EKS-Optimized AMI

# Architecture

<p align="center">
<img src="docs/diagram.png" width="400">
</p>


  * **VPC**: Amazon Amazon Virtual Private Cloud
  * **EKS**: Amazon Elastic Kubernetes Service
  * **ASG**: Amazon Auto Scaling group for node groups

# Requirements

In order to run this task, couple elements are required within the infrastructure:

  * Having an S3 bucket to store Terraform remote states [Here](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html)


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
|`aws_access_key`|Amazon AWS access key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.access_key))`|`True`|
|`aws_default_region`|Amazon AWS region to use for Terraform.|`-`|`eu-west-1`|`True`|
|`aws_secret_key`|Amazon AWS secret key for Terraform. See value format [here](https://docs.cycloid.io/advanced-guide/integrate-and-use-cycloid-credentials-manager.html#vault-in-the-pipeline)|`-`|`((aws.secret_key))`|`True`|
|`config_git_branch`|Branch of the config Git repository.|`-`|`master`|`True`|
|`config_git_private_key`|SSH key pair to fetch the config Git repository.|`-`|`((ssh_config.ssh_key))`|`True`|
|`config_git_repository`|Git repository URL containing the config of the stack.|`-`|`git@github.com:MyUser/config.git`|`True`|
|`config_terraform_path`|Path of Terraform files in the config git repository|`-`|`($ project $)/terraform/($ environment $)`|`True`|
|`customer`|Name of the Cycloid Organization, used as customer variable name.|`-`|`($ organization_canonical $)`|`True`|
|`env`|Name of the project's environment.|`-`|`($ environment $)`|`True`|
|`project`|Name of the project.|`-`|`($ project $)`|`True`|
|`stack_git_branch`|Branch to use on the public stack Git repository|`-`|`master`|`True`|
|`terraform_storage_bucket_name`|AWS S3 bucket name to store terraform remote state file.|`-`|`($ organization_canonical $)-terraform-remote-state`|`True`|
|`terraform_version`|terraform version used to execute your code.|`-`|`'0.12.28'`|`True`|


## Terraform

**Inputs**

|Name|Description|Type|Default|Required|
|---|---|:---:|:---:|:---:|
|`aws_zones`|To use specific AWS Availability Zones.|`-`|`{}`|`False`|
|`bastion_sg_allow`|Additionnal security group ID to assign to servers. Goal is to allow bastion server to connect on nodes port 22 (SSH). Make sure the bastion VPC is peered.|`-`|`""`|`False`|
|`cluster_enabled_log_types`|EKS cluster enabled log types.|`-`|`["api", "audit", "authenticator", "controllerManager", "scheduler"]`|`False`|
|`cluster_version`|EKS cluster version.|`-`|`1.16`|`False`|
|`control_plane_allowed_ips`|Allow Inbound IP CIDRs to access the Kubernetes API.|`-`|`["0.0.0.0/0"]`|`False`|
|`enable_dynamodb_endpoint`|Should be true if you want to provision a DynamoDB endpoint to the VPC.|`bool`|`false`|`False`|
|`enable_s3_endpoint`|Should be true if you want to provision an S3 endpoint to the VPC.|`bool`|`false`|`False`|
|`extra_tags`|Dict of extra tags to add on aws resources. format { "foo" = "bar" }.|`-`|`{}`|`False`|
|`keypair_name`|Name of an existing AWS SSH keypair to use to deploy EC2 instances.|`-`|`cycloid`|`False`|
|`metrics_sg_allow`|Additionnal security group ID to assign to servers. Goal is to allow monitoring server to query metrics. Make sure the prometheus VPC is peered.|`-`|`""`|`False`|
|`node_asg_max_size`|Maximum number of node servers allowed in the Auto Scaling Group.|`-`|`10`|`False`|
|`node_asg_min_size`|Minimum number of node servers allowed in the Auto Scaling Group.|`-`|`1`|`False`|
|`node_count`|Desired number of node servers.|`-`|`1`|`False`|
|`node_disk_size`|EKS nodes root disk size.|`-`|`60`|`False`|
|`node_disk_type`|EKS nodes root disk type.|`-`|`gp2`|`False`|
|`node_ebs_optimized`|Should be true if the instance type is using EBS optimized volumes.|`-`|`true`|`False`|
|`node_enable_cluster_autoscaler_tags`|Should be true to add Cluster Autoscaler ASG tags.|`-`|`false`|`False`|
|`node_group_name`|Node group given name.|`-`|`standard`|`False`|
|`node_launch_template_profile`|EKS nodes profile, can be either `ondemand` or `spot`.|`-`|`ondemand`|`False`|
|`node_spot_price`|EKS nodes spot price when `node_market_type = spot`.|`-`|`0.3`|`False`|
|`node_type`|Type of instance to use for node servers.|`-`|`c5.xlarge`|`False`|
|`private_subnets`|The private subnets for the VPC.|`list`|`["10.8.0.0/24", "10.8.2.0/24", "10.8.4.0/24"]`|`False`|
|`private_subnets_ids`|Amazon subnets IDs on which create each components.|`array`|``|`True`|
|`public_subnets`|The public subnets for the VPC.|`list`|`["10.8.1.0/24", "10.8.3.0/24", "10.8.5.0/24"]`|`False`|
|`public_subnets_ids`|Amazon subnets IDs on which create each components.|`array`|``|`True`|
|`vpc_cidr`|The CIDR of the VPC.|`-`|`10.8.0.0/16`|`False`|
|`vpc_id`|Amazon VPC id on which create each components.|`-`|``|`True`|

**Outputs**

| Name | Description |
|------|-------------|
| `vpc_id` | EKS Cluster VPC ID. |
| `vpc_cidr` | EKS Cluster dedicated VPC CIDR. |
| `public_subnets` | EKS Cluster VPC public subnets. |
| `private_subnets` | EKS Cluster VPC private subnets. |
| `public_route_table_ids` | EKS Cluster dedicated VPC public route table IDs. |
| `private_route_table_ids` | EKS Cluster dedicated VPC private route table IDs.
| `private_zone_id` | EKS Cluster dedicated VPC private zone ID. |
| `private_zone_name` | EKS Cluster dedicated VPC private zone name. |
| `region`| Amazon AWS region used to deploy the cluster.|
| `cluster_name` | EKS Cluster name. |
| `cluster_version` | EKS Cluster version. |
| `cluster_platform_version` | EKS Cluster plateform version. |
| `control_plane_sg_id` | EKS Cluster Security Group ID. |
| `control_plane_endpoint` | EKS Cluster endpoint. |
| `control_plane_ca` | EKS Cluster certificate authority. |
| `control_plane_openid_issuer_url` | EKS Cluster OpenID Connect issuer URL. |
| `node_iam_role_arn` | EKS nodes IAM role ARN. |
| `node_iam_instance_profile_name` | EKS nodes IAM instance profile name. |
| `kubeconfig` | Kubernetes config to connect to the EKS cluster. |


# Help

## How to connect the k8s api from linux with aws cli

Generate your kubeconfig with [aws eks](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html#create-kubeconfig-manually) command
```
export AWS_ACCESS_KEY_ID=AKI....
export AWS_SECRET_ACCESS_KEY=Secret
aws eks --region <region> update-kubeconfig --name <cluster_name>
```

# Known Issues

## Service `type: LoadBalancers` target groups healthcheck failure

There is a known issue about K8S Services of `type: LoadBalancers` having healthcheck failures. @see https://github.com/kubernetes/kubernetes/issues/61486

The temporary solution is to patch the `kube-proxy` daemonset:

```sh
kubectl -n kube-system patch daemonset kube-proxy --patch "$(cat extra/aws_lb_kube-proxy.yml.patch)"
```
