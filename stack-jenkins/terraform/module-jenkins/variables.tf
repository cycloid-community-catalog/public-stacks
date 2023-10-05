variable "bastion_sg_allow" {
  description = "AWS SG to allow inbound remote connection"
}

variable "env" {
}

variable "customer" {
}

variable "zones" {
  type    = list(string)
  default = []
}

variable "keypair_name" {
  default = "cycloid"
  description  = "AWS SSH keypair to install on the EC2 instance"
}

variable "public_subnets_ids" {
  type = list(string)
  description = "list of subnet IDs in the VPC to deploy the EC2 instance. A subnet will be randomly picked-up"
}

variable "vpc_id" {
  default = ""
  description = "ID of the AWS VPC to deploy the EC2 instance"
}

variable "project" {
  default = "jenkins"
}

variable "extra_tags" {
  default = {}
  description ="extra tags to add to the EC2 instance"
}

variable "jenkins_disk_size" {
  default = 60
  description = "size (GB) of the Jenkins EC2 instance disk"
}

variable "jenkins_disk_type" {
  default = "gp2"
  description = "type of the Jenkins EC2 instance disk"
}

variable "jenkins_type" {
  default = "t3.small"
  description = "type of the Jenkins EC2 instance"
}

variable "jenkins_ebs_optimized" {
  default = true
  description  = "is the Jenkins EC2 instance is EBS optimized. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html"
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
