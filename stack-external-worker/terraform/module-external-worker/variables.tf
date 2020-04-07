data "aws_region" "current" {
}

variable "bastion_sg_allow" {
  default = ""
}

variable "metrics_sg_allow" {
  default = ""
}

variable "project" {
  default = "external-worker"
}

variable "customer" {
}

variable "env" {
}

variable "short_region" {
  type = map(string)

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
  default = "cycloid-external-worker"
}

variable "extra_tags" {
  default = {}
}

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    client       = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}

variable "private_subnets_ids" {
  type    = list(string)
  default = []
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "zones" {
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "vpc_id" {
}

#
# worker
#
variable "worker_count" {
}

variable "worker_ami_id" {
  default = ""
}

variable "worker_spot_price" {
  default = "0.3"
}

variable "worker_extra_args" {
  default = ""
}

variable "worker_disk_size" {
  default = "20"
}

variable "worker_disk_type" {
  default = "gp2"
}

variable "worker_volume_disk_size" {
  default = "100"
}

variable "worker_volume_disk_type" {
  default = "gp2"
}

variable "worker_launch_template_profile" {
  default = "spot"
}

variable "worker_launch_template_id" {
  default = ""
}

variable "worker_launch_template_latest_version" {
  default = ""
}

variable "worker_type" {
  default = "c5d.2xlarge"
}

variable "worker_ebs_optimized" {
  default = true
}

variable "worker_associate_public_ip_address" {
  default = true
}

variable "worker_asg_min_size" {
  default = 1
}

variable "worker_asg_max_size" {
  default = 2
}

variable "worker_asg_scale_up_scaling_adjustment" {
  default = 1
}

variable "worker_asg_scale_up_cooldown" {
  default = 300
}

variable "worker_asg_scale_up_threshold" {
  default = 80
}

variable "worker_asg_scale_down_scaling_adjustment" {
  default = -1
}

variable "worker_asg_scale_down_cooldown" {
  default = 300
}

variable "worker_asg_scale_down_threshold" {
  default = 40
}
