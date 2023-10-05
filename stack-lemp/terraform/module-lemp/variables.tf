data "aws_region" "current" {}

variable "bastion_sg_allow" {
}

variable "metrics_sg_allow" {
  default = ""
}

variable "project" {
  default = "lemp"
}

variable "env" {
}

variable "customer" {
}

variable "extra_tags" {
  default = {}
}

variable "keypair_name" {
  default = "cycloid"
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "cache_subnet_group" {
  default = ""
}

variable "vpc_id" {
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Example ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
variable "zones" {
  description = "To use specific AWS Availability Zones."
  default     = []
}

locals {
  aws_availability_zones = length(var.zones) > 0 ? var.zones : data.aws_availability_zones.available.names
}

#
# s3 medias
#

variable "create_s3_medias" {
  default = false
}

variable "s3_medias_acl" {
  default = "private"
}

variable "s3_medias_policy_json" {
  default = ""
}

#
# RDS
#

variable "create_rds" {
  default = false
}

variable "rds_database" {
  default = "application"
}

variable "rds_disk_size" {
  default = 10
}

variable "rds_multiaz" {
  default = false
}

variable "rds_password" {
  default = "ChangeMePls"
}

variable "rds_type" {
  default = "db.t3.small"
}

variable "rds_username" {
  default = "application"
}

variable "rds_storage_type" {
  default = "gp2"
}

variable "rds_subnet_group" {
  default = ""
}

variable "rds_parameters" {
  default = "default.mysql5.7"
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

variable "rds_skip_final_snapshot" {
  default = true
}

variable "rds_extra_sg_allow" {
  default = ""
}

#
# Application
#

variable "application_ssl_cert" {
  default = ""
}

variable "application_ssl_policy" {
  # ELBSecurityPolicy-2015-05
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "application_health_check_path" {
  default = "/health-check"
}

variable "application_health_check_matcher" {
  default = 200
}

variable "application_path_health_timeout" {
  default = 15
}

variable "application_path_health_interval" {
  default = 45
}

###

# front

###

variable "front_disk_size" {
  default = 30
}

variable "front_disk_type" {
  default = "gp2"
}

variable "front_type" {
  default = "t3.small"
}

variable "front_ebs_optimized" {
  default = false
}

variable "front_count" {
  default = 1
}

variable "front_associate_public_ip_address" {
  default = false
}

variable "debian_ami_name" {
  default = "debian-11-amd64-*"
}

#
# ASG
#

variable "front_asg_min_size" {
  default = 1
}

variable "front_asg_max_size" {
  default = 5
}

variable "front_asg_scale_up_scaling_adjustment" {
  default = 2
}

variable "front_asg_scale_up_cooldown" {
  default = 300
}

variable "front_asg_scale_up_threshold" {
  default = 85
}

variable "front_asg_scale_down_scaling_adjustment" {
  default = -1
}

variable "front_asg_scale_down_cooldown" {
  default = 500
}

variable "front_asg_scale_down_threshold" {
  default = 30
}

variable "front_update_min_in_service" {
  default = 1
}

###

# ElastiCache

###

variable "create_elasticache" {
  default = false
}

variable "elasticache_type" {
  default = "cache.t2.micro"
}

variable "elasticache_nodes" {
  default = 1
}

variable "elasticache_engine" {
  default = "redis"
}

variable "elasticache_parameter_group_name" {
  default = "default.redis5.0"
}

variable "elasticache_engine_version" {
  default = "5.0.6"
}

variable "elasticache_port" {
  default = "6379"
}

variable "elasticache_cluster_id" {
  default = ""
}

variable "default_short_name" {
  default = ""
}

resource "random_string" "id" {
  length  = 18
  upper   = false
  special = false
}

#local.default_short_name is lenght 20
locals {
  elasticache_cluster_id = var.elasticache_cluster_id != "" ? var.elasticache_cluster_id : "cy${random_string.id.result}"
  default_short_name     = var.default_short_name != "" ? var.default_short_name : "cy${random_string.id.result}"
}

#Used to only keep few char for component like ALB name
variable "nameregex" {
  default = "/[^0-9A-Za-z-]/"
  type    = string
}

variable "deploy_bucket_name" {
  default = "application-deployment"
}

variable "front_ami_id" {
  default = ""
}


# Ses

variable "create_ses_access" {
  default = false
}

variable "ses_resource_arn" {
  default = "*"
}

# Cloudfront

variable "create_cloudfront_medias" {
  default = false
}

variable "cloudfront_ssl_certificate" {
  default = "arn:aws:acm:us-east-1:xxxxxxxx:certificate/xxxxxxx"
}

variable "cloudfront_aliases" {
  type    = list(string)
  default = []
}

variable "cloudfront_price_class" {
  default = "PriceClass_200"
}

variable "cloudfront_minimum_protocol_version" {
  default = "TLSv1"
}

variable "cloudfront_min_ttl" {
  default = 0
}
variable "cloudfront_default_ttl" {
  default = 300
}

variable "cloudfront_max_ttl" {
  default = 1200
}

variable "cloudfront_compress" {
  default = true
}

variable "cloudfront_cached_methods" {
  default = ["GET", "HEAD"]
}
