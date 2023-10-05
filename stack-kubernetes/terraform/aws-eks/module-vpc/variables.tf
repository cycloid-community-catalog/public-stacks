#
# General
#

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "aws_zones" {
  description = "To use specific AWS Availability Zones."
  default     = []
}

locals {
  aws_availability_zones = length(var.aws_zones) > 0 ? var.aws_zones : data.aws_availability_zones.available.names
}

variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

variable "extra_tags" {
  description = "Extra tags to add to all resources."
  default     = {}
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

#
# Networking
#

variable "vpc_cidr" {
  description = "The CIDR of the VPC."
  default     = "10.8.0.0/16"
}

variable "private_subnets" {
  description = "The private subnets for the VPC."
  default     = ["10.8.0.0/24", "10.8.2.0/24", "10.8.4.0/24"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC."
  default     = ["10.8.1.0/24", "10.8.3.0/24", "10.8.5.0/24"]
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks."
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.aws_zones` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.aws_zones`."
  default     = false
}

#
# VPC endpoints
#

variable "enable_dynamodb_endpoint" {
  description = "Should be true if you want to provision a DynamoDB endpoint to the VPC."
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC."
  default     = false
}

#
# Control plane
#

variable "cluster_name" {
  description = "EKS Cluster given name."
}