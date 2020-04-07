module "prometheus" {
  #####################################
  # Do not modify the following lines #
  source = "./module-prometheus"

  project    = var.project
  env        = var.env
  customer   = var.customer
  aws_region = var.aws_region

  #####################################

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id = "infra_vpc_id"
  #. keypair_name (optional): cycloid
  #+ SSH keypair name to use to deploy ec2 instances.
  keypair_name = "keypair_name"
  #. bastion_sg_allow (optional):
  #+ Amazon source security group ID which will be allowed to connect on Fronts port 22 (ssh).
  bastion_sg_allow = "infra_bastion_sg_allow"
  #. public_subnets_ids (required, array):
  #+ Amazon subnets IDs on which create each components.
  public_subnets_ids = ["infra_public_subnets"]

  #. private_subnets_ids (optional, array): []
  #+ Amazon subnets IDs on which create each components. Used when create_rds_database is true.
  #private_subnets_ids = data.terraform_remote_state.infrastructure.outputs.infra_private_subnets

  #. prometheus_type (optional): t3.small
  #+ Amazon EC2 instance type for Prometheus server.

  #. prometheus_disk_size (optional): 60
  #+ Disk size for the Prometheus server.

  #. enable_https (optional, bool): false
  #+ Open or not the HTTPS port on the EC2 instance.

  #. create_rds_database (optional, bool): true
  #+ create a rds database generaly used for grafana. **false** will not create the database

  #. rds_type (optional): db.t3.small
  #+ RDS database instance size

  #. rds_disk_size (optional): 10
  #+ RDS database disk size

  #. rds_database (optional): grafana
  #+ RDS database name

  #. rds_username (optional): grafana
  #+ RDS database username

  #. rds_password (optional): ChangeMePls
  #+ RDS password. expected value is var.rds_password to get it from the pipeline.
}

# Example of security group to allow prometheus server to reach your infra and prod vpc


#resource "aws_security_group" "infra_allow_metrics" {
#  name        = "infra_allow_metrics"
#  description = "Allow metrics server to collect metrics"
#  vpc_id      = data.terraform_remote_state.infrastructure.outputs.infra_vpc_id
#
#  ingress {
#    from_port       = 9100
#    to_port         = 9100
#    protocol        = "tcp"
#    security_groups = [module.prometheus.prometheus_secgroup_id]
#    self            = false
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    Name         = "${var.project}-infra-allow-metrics"
#    customer     = "${var.customer}"
#    project      = "${var.project}"
#    env          = "${var.env}"
#    "cycloid.io" = "true"
#  }
#}
#
#output "infra_metrics_sg_allow" {
#  value = aws_security_group.infra_allow_metrics.id
#}


#resource "aws_security_group" "prod_allow_metrics" {
#  name        = "prod_allow_metrics"
#  description = "Allow metrics server to collect metrics"
#  vpc_id      = data.terraform_remote_state.infrastructure.outputs.prod_vpc_id
#
#  ingress {
#    from_port       = 9100
#    to_port         = 9100
#    protocol        = "tcp"
#    security_groups = [module.prometheus.prometheus_secgroup_id]
#    self            = false
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    Name         = "${var.project}-prod-allow-metrics"
#    customer     = "${var.customer}"
#    project      = "${var.project}"
#    env          = "${var.env}"
#    "cycloid.io" = "true"
#  }
#}
#
#output "prod_metrics_sg_allow" {
#  value = aws_security_group.prod_allow_metrics.id
#}


#resource "aws_security_group" "staging_allow_metrics" {
#  name        = "staging_allow_metrics"
#  description = "Allow metrics server to collect metrics"
#  vpc_id      = data.terraform_remote_state.infrastructure.outputs.staging_vpc_id
#
#  ingress {
#    from_port       = 9100
#    to_port         = 9100
#    protocol        = "tcp"
#    security_groups = [module.prometheus.prometheus_secgroup_id]
#    self            = false
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags = {
#    Name         = "${var.project}-staging-allow-metrics"
#    customer     = "${var.customer}"
#    project      = "${var.project}"
#    env          = "${var.env}"
#    "cycloid.io" = "true"
#  }
#}
#
#output "staging_metrics_sg_allow" {
#  value = aws_security_group.staging_allow_metrics.id
#}

