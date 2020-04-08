# See the variables.tf file in module-concourse-server for a complete description
# of the options

variable "rds_password" {
    default = "ChangeMePls"
}

module "concourse-server" {

  #####################################
  # Do not modify the following lines #
  source = "module-concourse-server"

  project  = "${var.project}"
  env      = "${var.env}"
  customer = "${var.customer}"
  aws_region  = "${var.aws_region}"
  #####################################

  #. bastion_sg_allow (optional):
  #+ Amazon source security group ID which will be allowed to connect on Magento front port 22 (ssh)
  bastion_sg_allow         = "bastion-sg-id"

  #. keypair_name (requiredl): cycloid-concourse-server
  #+ SSH keypair name to use to deploy ec2 instances
  keypair_name            = "cycloid-concourse-server"

  #. metrics_sg_allow (optional): ""
  #+ Additionnal security group ID to assign to Cycloid workers. Goal is to allow monitoring server to query metrics
  metrics_sg_allow        = "metrics-sg-id"

  #. public_subnets_ids (required, array):
  #+ Amazon public subnets IDs on which create each components.
  public_subnets_ids      = ["public-subnets-ids"]

  #. private_subnets_ids (required, array):
  #+ Amazon private subnets IDs on which create each components.
  private_subnets_ids     = ["private-subnets-ids"]

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id                  = "vpc-id"

  #
  # EC2 configuration
  #

  #. concourse_disk_size (optional): 20
  #+ Root disk size in Go of AWS EC2 concourse servers.

  #. concourse_volume_disk_size (optional): 100
  #+ Volume disk size in Go of AWS EC2 concourse servers.

  #. concourse_ebs_optimized (optional, bool): true
  #+ Whether the Instance is EBS optimized or not, related to the instance type you choose.

  #. concourse_type (optional): t3.small
  #+ Type of AWS EC2 concourse servers. This will be used for "spot" and "ondemand" launch config templates

  #. concourse_associate_public_ip_address (optional, bool): true
  #+ Assosiate or not an Amazon public IP to Concourse servers.

  #
  # ALB configuration
  #

  # create a dedicated ALB

  #. concourse_create_alb (optional, bool): true
  #+ Create a dedicated ALB on top of Concourse servers.

  #.concourse_acm_certificate_arn (optional): "<acm-certificate-arn>"
  #+ mandatory if concourse_create_alb = true. Define Amazon certificate ACM to use for the SSL listener.

  # use an existing ALB

  #. concourse_create_alb (optional, bool): false
  #+ Use an existing ALB on top of Concourse servers instead of creating a new one.

  #. concourse_alb_listener_arn (optional):
  #+ mandatory if concourse_create_alb = false, ARN of the dedicated listener for Concourse servers.

  #. concourse_alb_security_group_id (optional):
  #+ mandatory if concourse_create_alb = false. Security group ID of the ALB.

  #. concourse_domain (required): ""
  # Concourse domain nane, used for the ALB listener rule.
  concourse_domain = "ci-stack-concourse-server.master"

  #
  # NLB configuration
  #

  #. workers_sg_allow (required, list):
  #+ List of workers security groups of Concourse workers to allow.
  workers_sg_allow    = []

  #. workers_cidr_allow (required, list):
  #+ List of CIDR of Concourse workers to allow.
  workers_cidr_allow  = []

  #
  # RDS configuration
  #

  #. rds_password (optional): ChangeMePls
  #+ RDS password. expected value is "${var.rds_password}" to get it from the pipeline.
  rds_password            = "${var.rds_password}"

  #. rds_database (optional): concourse
  #+ RDS database name.

  #. rds_disk_size (optional): 50
  #+ RDS disk size.

  #. rds_multiaz (optional, bool): false
  #+ If the RDS instance is multi AZ enabled.

  #. rds_type (optional): db.t3.small
  #+ RDS database instance size.

  #. rds_username (optional): concourse
  #+ RDS database username.

  #. rds_engine (optional): postgres
  #+ RDS database engine to use.

  #. rds_engine_version (optional): 9.5
  #+ The version of the RDS database engine

  #. rds_maintenance_window (optional): "tue:06:00-tue:07:00"
  #+ The window to perform maintenance in. Syntax: "ddd:hh24:mi-ddd:hh24:mi". Eg: "Mon:00:00-Mon:03:00".

  #. rds_backup_window (optional): "02:00-04:00"
  #+ The daily time range (in UTC) during which automated backups are created if they are enabled. Example: "09:46-10:16". Must not overlap with maintenance_window.

  #. rds_backup_retention (optional): 7
  #+ The days to retain backups for. Must be between 0 and 35. When creating a Read Replica the value must be greater than 0

  #. rds_skip_final_snapshot (optional, bool): false
  #+ Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created

  #. rds_parameters (optional): Use the stack included parameters
  #+ Name of the DB parameter group to associate.

  #. rds_subnet_group (optional): create a dedicated group with private_subnets_ids
  #+ RDS subnet group name to use. If not specified, create a dedicated group with private_subnets_ids.

  #. rds_postgresql_family (optional): postgres9.5
  #+ The family of the DB parameter group. Used if rds_parameters is not specified.
}
