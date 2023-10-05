# See the variables.tf file in module-infrastructure for a complete description
# of the options

module "infrastructure" {
  #####################################
  # Do not modify the following lines #
  source = "./module-infrastructure"
  project = var.project
  env     = var.env
  customer = var.customer
  #####################################

  #. keypair_name: "${var.customer}-${var.project}${var.suffix}"
  #+ The human-readable keypair name to be used for instances deployment

  #. keypair_public (required):
  #+ The public SSH key, for SSH access to newly-created instances
  keypair_public = "ssh-rsa XXX"

  #. zones: []
  #+ To use specific AWS Availability Zones.

  #. enable_dynamodb_endpoint (optional, bool): false
  #+ Should be true if you want to provision a DynamoDB endpoint to the VPC
  #enable_dynamodb_endpoint = false

  #. enable_s3_endpoint (optional, bool): false
  #+ Should be true if you want to provision an S3 endpoint to the VPC
  #enable_s3_endpoint = false

  #
  # infra VPC
  #

  #. infra_cidr: 10.0.0.0/16
  #+ The CIDR of the infra VPC
  infra_cidr = "10.0.0.0/16"

  #. infra_private_subnets (optional, list): ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]
  #+ The private subnets for the infra VPC
  infra_private_subnets = ["10.0.0.0/24", "10.0.2.0/24", "10.0.4.0/24"]

  #. infra_public_subnets (optional, list): ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  #+ The public subnets for the infra VPC
  infra_public_subnets = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]

  #. infra_associate_vpc_to_all_private_zones (optional, bool): false
  #+ Should be true if you want to associate the infra VPC to staging and prod privates zones.
  #infra_associate_vpc_to_all_private_zones = false

  #
  # staging VPC
  #

  #. staging_cidr: 10.1.0.0/16
  #+ The CIDR of the staging VPC
  staging_cidr = "10.1.0.0/16"

  #. staging_private_subnets (optional, list): ["10.1.0.0/24", "10.1.2.0/24", "10.1.4.0/24"]
  #+ The private subnets for the staging VPC
  staging_private_subnets = ["10.1.0.0/24", "10.1.4.0/24", "10.1.8.0/24"]

  #. staging_public_subnets (optional, list): ["10.1.1.0/24", "10.1.3.0/24", "10.1.5.0/24"]
  #+ The public subnets for the staging VPC
  staging_public_subnets = ["10.1.1.0/24", "10.1.5.0/24", "10.1.9.0/24"]

  #. staging_rds_subnets (optional, list): ["10.1.2.0/24", "10.1.6.0/24", "10.1.10.0/24"]
  #+ The RDS subnets for the staging VPC
  staging_rds_subnets = ["10.1.2.0/24", "10.1.6.0/24", "10.1.10.0/24"]

  #. staging_elasticache_subnets (optional, list): []
  #+ The Elasticache subnets for the staging VPC

  #
  # prod VPC
  #

  #. prod_cidr: 10.2.0.0/16
  #+ The CIDR of the prod VPC
  prod_cidr                = "10.2.0.0/16"

  #. prod_private_subnets (optional, list): ["10.2.0.0/24", "10.2.2.0/24", "10.2.4.0/24"]
  #+ The private subnets for the prod VPC
  prod_private_subnets     = ["10.2.0.0/24", "10.2.4.0/24", "10.2.8.0/24"]

  #. prod_public_subnets (optional, list): ["10.2.1.0/24", "10.2.3.0/24", "10.2.5.0/24"]
  #+ The public subnets for the prod VPC
  prod_public_subnets      = ["10.2.1.0/24", "10.2.5.0/24", "10.2.9.0/24"]

  #. prod_rds_subnets (optional, list): ["10.2.2.0/24", "10.2.6.0/24", "10.2.10.0/24"]
  #+ The RDS subnets for the prod VPC
  prod_rds_subnets         = ["10.2.2.0/24", "10.2.6.0/24", "10.2.10.0/24"]

  #. prod_elasticache_subnets (optional, list): []
  #+ The Elasticache subnets for the prod VPC


  #. bastion_allowed_networks: 0.0.0.0/0
  #+ Networks allowed to connect to the bastion using SSH

  #. bastion_instance_type: t3.micro
  #+ Instance type for the bastion

  #. backup_bucket_prefix: ""
  #+ Prefix for the S3 backup bucket (change it if a bucket with the same name already exists) - defaults to '${var.customer}-'
  backup_bucket_prefix = "${var.customer}-${var.env}-"

  #. extra_admin_users (optional, list): []
  #+ List of users to give the administrator access role to
  #extra_admin_users = ["admin"]

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources.
  #extra_tags = { "foo" = "bar" }

  #. readonly_users (optional, list): []
  #+ List of users to give a read-only access to

  #. readonly_groups (optional, list): []
  # List of groups to give a read-only access to

  #. metrics_allowed_sg:
  # Security group allowed to reach metrics ports like the node exporter one
  #+ If you use the prometheus stack, you can define the provider and define the metrics_allowed_sg variable after creating promeheus
  #+ First create infra, second create prometheus, third uncomment variable
  # metrics_allowed_sg = "${data.terraform_remote_state.prometheus.infra_metrics_sg_allow}"

  #. create_s3_bucket_remote_state (optional, bool): false
  #+ terraform_remote_state s3 bucket has to be created or not
  #create_s3_bucket_remote_state = false

  #. create_infra_user (optional, bool): false
  #+ If an admin user infra has to be created or not
  #create_infra_user = false

  #. create_backup_user (optional, bool): false
  #+ If a backup user has to be created or not
  #create_backup_user = false
}


#data "terraform_remote_state" "prometheus" {
#  backend = "s3"
#
#  config {
#    bucket = "${var.customer}-terraform-remote-state"
#    key    = "prometheus/infra/prometheus-infra.tfstate"
#    region = "eu-west-1"
#  }
#}
