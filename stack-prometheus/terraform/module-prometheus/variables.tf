variable "aws_region" {
  default = "eu-west-1"
}

variable "bastion_sg_allow" {
}

variable "env" {
}

variable "customer" {
}

variable "short_region" {
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

variable "zones" {
  type    = list(string)
  default = []
}

variable "keypair_name" {
  default = "cycloid"
}

variable "private_subnets_ids" {
  type    = list(string)
  default = [""]
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "vpc_id" {
  default = ""
}

variable "project" {
  default = "prometheus"
}

variable "enable_https" {
  default = false
}

variable "extra_tags" {
  default = {}
}

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}

###

# prometheus

###

variable "debian_ami_name" {
  default = "debian-stretch-*"
}

variable "prometheus_disk_size" {
  default = 60
}

variable "prometheus_disk_type" {
  default = "gp2"
}

variable "prometheus_type" {
  default = "t3.small"
}

variable "prometheus_ebs_optimized" {
  default = true
}

variable "prometheus_enable_eip" {
  default = true
}

###

# grafana

###
variable "create_rds_database" {
  description = "**true** create a rds database generaly used for grafana. **false** will not create the database"
  default     = true
}

variable "rds_database" {
  default = "grafana"
}

variable "rds_disk_size" {
  default = 10
}

variable "rds_multiaz" {
  default = true
}

variable "rds_password" {
  default = "ChangeMePls"
}

variable "rds_type" {
  default = "db.t3.small"
}

variable "rds_username" {
  default = "grafana"
}

variable "rds_engine" {
  default = "mysql"
}

variable "rds_engine_version" {
  default = "5.7.16"
}

variable "rds_backup_retention" {
  default = 7
}

variable "rds_parameters" {
  default = ""
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_skip_final_snapshot" {
  default = false
}

