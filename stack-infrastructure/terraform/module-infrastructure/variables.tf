##### Meta information

variable "customer" {
  description = "Name of the infrastructure (as used internally by Cycloid, the customer name)"
  default     = ""
}

variable "project" {
  description = "Name of the project"
  default     = "infrastructure"
}

variable "env" {
  description = "Name of the env (for display in the AWS console)"
  default     = "infra"
}

variable "suffix" {
  description = "Suffix for all resources names, useful if the infrastructure stack is deployed twice on the same AWS account"
  default     = ""
}

variable "backup_bucket_prefix" {
  description = "Prefix for the S3 backup bucket (change it if a bucket with the same name already exists) - defaults to '${var.customer}-'"
  default     = ""
}

##### S3 bucket

variable "create_s3_bucket_remote_state" {
  description = "To know if a terraform_remote_state s3 bucket has to be created or not"
  default     = 0
}

##### IAM and authorizations

variable "create_infra_user" {
  description = "To know if an admin user infra has to be created or not"
  default     = 0
}

variable "extra_admin_users" {
  description = "List of users to give the administrator access role to"
  default     = []
}

variable "readonly_users" {
  description = "List of users to give a read-only access to"
  default     = []
}

variable "readonly_groups" {
  description = "List of groups to give a read-only access to"
  default     = []
}

##### Keypair

variable "keypair_name" {
  description = "The human-readable keypair name to be used for instances deployment"
  default     = ""
}

variable "keypair_public" {
  description = "The public SSH key, for SSH access to newly-created instances"
}

##### Network environment

# Please note the VPCs are created even if we don't need them. That's because
# we can't add the count parameter to the modules yet.
# Oce we can "count" the modules, we may even use a list of maps, allowing to
# define any number of VPCs.

variable "aws_region" {
  description = "Name of the region where the infrastructure is created"
  default     = "us-east-1"
}

variable "zones" {
  description = "The availability zones you want to use"
  default     = []
}

# Allow metrics (prometheus) to collect data from bastion
variable "metrics_allowed_sg" {
  default     = ""
  description = "Security group allowed to reach metrics ports like the node exporter one"
}

# Vpc endpoint

variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC"
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  default     = false
}
