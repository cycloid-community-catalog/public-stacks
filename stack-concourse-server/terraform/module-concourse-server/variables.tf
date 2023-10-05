variable "aws_region" {
  default = "eu-west-1"
}

variable "bastion_sg_allow" {
  default = ""
}

variable "metrics_sg_allow" {
  default = ""
}

variable "project" {
  default = "concourse-server"
}

variable "customer" {}

variable "env" {}

variable "short_region" {
  type = "map"

  default = {
    ap-northeast-1 = "ap-no1"
    ap-northeast-2 = "ap-no2"
    ap-southeast-1 = "ap-so1"
    ap-southeast-2 = "ap-so2"
    eu-central-1   = "eu-ce1"
    eu-west-1      = "eu-we1"
    eu-west-2      = "eu-we2"
    eu-west-3      = "eu-we3"
    sa-east-1      = "sa-ea1"
    us-east-1      = "us-ea1"
    us-west-1      = "us-we1"
    us-west-2      = "us-we2"
  }
}

variable "keypair_name" {
  default = "cycloid"
}

variable "private_subnets_ids" {
  type = "list"
}

variable "public_subnets_ids" {
  type = "list"
}

variable "zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "vpc_id" {}

#
# RDS
#
variable "rds_database" {
  default = "concourse"
}

variable "rds_disk_size" {
  default = "50"
}

variable "rds_multiaz" {
  default = true
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_type" {
  default = "db.t2.small"
}

variable "rds_username" {
  default = "concourse"
}

variable "rds_password" {
  default = "ChangeMePls"
}

variable "rds_engine" {
  default = "postgres"
}

variable "rds_engine_version" {
  default = "9.5"
}

variable "rds_maintenance_window" {
  default = "tue:06:00-tue:07:00"
}

variable "rds_backup_window" {
  default = "02:00-04:00"
}

variable "rds_backup_retention" {
  default = 7
}

variable "rds_skip_final_snapshot" {
  default = false
}

variable "rds_parameters" {
  default = ""
}

variable "rds_subnet_group" {
  default = ""
}

variable "rds_postgresql_family" {
  description = "The family of the Postgresql DB parameter group (ex: postgres9.4)"
  default     = "postgres9.5"
}

#
# concourse server
#
variable "concourse_count" {
  default = 1
}

variable "concourse_extra_args" {
  default = ""
}

variable "concourse_disk_size" {
  default = "20"
}

variable "concourse_disk_type" {
  default = "gp2"
}

variable "concourse_volume_disk_size" {
  default = "50"
}

variable "concourse_volume_disk_type" {
  default = "gp2"
}

variable "concourse_type" {
  default = "t3.small"
}

variable "concourse_ebs_optimized" {
  default = true
}

variable "concourse_associate_public_ip_address" {
  default = true
}

variable "concourse_asg_min_size" {
  default = 1
}

variable "concourse_asg_max_size" {
  default = 1
}

variable "concourse_asg_scale_up_scaling_adjustment" {
  default = 1
}

variable "concourse_asg_scale_up_cooldown" {
  default = 300
}

variable "concourse_asg_scale_up_threshold" {
  default = 80
}

variable "concourse_asg_scale_down_scaling_adjustment" {
  default = -1
}

variable "concourse_asg_scale_down_cooldown" {
  default = 300
}

variable "concourse_asg_scale_down_threshold" {
  default = 40
}

#
# ALB
#
variable "concourse_create_alb" {
  default = true
}

# mandatory if concourse_create_alb = true
variable "concourse_acm_certificate_arn" {
  default = ""
}

# mandatory if concourse_create_alb = false
variable "concourse_alb_listener_arn" {
  default = ""
}

variable "concourse_alb_security_group_id" {
  default = ""
}

variable "concourse_domain" {}

#
# NLB
#
variable "workers_sg_allow" {
  type = "list"
}

variable "workers_cidr_allow" {
  type = "list"
}
