data "aws_region" "current" {}

variable "env" {
}

variable "customer" {
}

variable "project" {
  default = "ses"
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

# A default is provided to avoid forcing to specify it
variable "vpc_id" {
  description = "The VPC ID to use when creating Security Groups entities"
  default     = "unset"
}

###
# ses
###

#verified domain used to send email
variable "mail_domain" {
}

###
# sns
###
variable "create_sqs" {
  description = "**true** to create an sqs generaly used for bounce email"
  default     = false
}

###
# redis
###
variable "create_elasticache" {
  description = "**true** to create an elasticache generaly used for queuing email"
  default     = false
}

variable "elasticache_type" {
  default = "cache.t2.micro"
}

variable "elasticache_name" {
  description = "Variable used for tagging / naming resources"
  default     = "redis"
}

variable "elasticache_port" {
  default = "6379"
}

variable "elasticache_parameter_group_name" {
  default = "default.redis5.0.cluster.on"
}

variable "elasticache_subnet_group_name" {
  default = ""
}

variable "elasticache_engine_version" {
  default = "5.0.0"
}

variable "elasticache_replicas_per_node_group" {
  description = "Number of read replica, should be between 0 and 5."
  default     = "1"
}

variable "elasticache_automatic_failover_enabled" {
  default = true
}

variable "elasticache_num_node_groups" {
  default = "1"
}

variable "elasticache_security_groups" {
  description = "Those security groups will be granted access to the elasticache cluster."
  type        = list(string)
  default     = []
}

variable "elasticache_maintenance_window" {
  default = "tue:06:00-tue:07:00"
}

