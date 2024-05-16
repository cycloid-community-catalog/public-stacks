###
# CYCLOID REQUIREMENTS
###
variable "env" {
  description = "Cycloid project name."
}

variable "project" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

###
# AMI DATA
###
variable "ami_most_recent" {
  description = "If more than one result is returned, use the most recent AMI."
  default     = true
}

variable "ami_name" {
  description = "The name of the AMI (provided during image creation)."
  default     = "debian-stretch-*"
}

variable "ami_virtualisation_type" {
  description = "The AMI virtualization type."
  default     = "hvm"
}

variable "ami_architecture" {
  description = "The AMI image architecture"
  default     = "x86_64"
}

variable "ami_root_device_type" {
  description = "The AMI type of the root device volume."
  default     = "ebs"
}

variable "ami_owners" {
  description = "List of AMI owners to limit search."
  default = [
    "379101102735",
    "136693071363",
    "125523088429",
    "099720109477",
    "309956199498",
  ]
  #"379101102735", # old debian
  #"136693071363", # debian10 & debian11
  #"125523088429", # centos
  #"099720109477", # Ubuntu
  #"309956199498", # RHEL9 ami-013d87f7217614e10
}

###
# Cloud init template
###
variable "file_content" {
  description = "The content of the file to use if cloud init is used."
}

###
# Security Group
###
variable "sg_name" {
  description = "Name of the security group."
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID used to create the security group."
  default     = ""
}

variable "sg_ingress_rules" {
  description = "Configuration block for ingress rules."
  default = [
    {
      description      = "Accept ssh traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]
}

variable "sg_egress_rules" {
  description = "Configuration block for egress rules."
  default = [
    {
      description      = "Accept all egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]
}

variable "sg_extra_tags" {
  description = "Map of extra tags to assign to the security group."
  default     = {}
}


###
# EC2
###
variable "instance_type" {
  description = "The instance type to use for the instance. "
  default     = "t2.micro"
}

variable "instance_extra_tags" {
  description = "A map of tags to assign to the resource."
  default     = {}
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance."
  default     = ""
}

//EC2- Network
variable "subnet_id" {
  description = "VPC Subnet ID to launch in."
  default     = ""
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC."
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC."
  default     = true
}

//EC2- Storage
variable "enable_vm_disk_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "enable_vm_disk_encrypted" {
  description = "Whether to enable volume encryption."
  default     = false
}
variable "vm_disk_size" {
  description = "Size of the volume in gibibytes (GiB)."
  default     = 5
}
variable "vm_disk_type" {
  description = "Type of volume."
  default     = "gp2"
}
variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized."
  default     = false
}

variable "volume_extra_tags" {
  description = "A map of tags to assign, at instance-creation time, to root and EBS volumes."
  default     = {}
}

###
# TAGS + SG name
###

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    client       = var.customer
    organization = var.customer
  }
  sg_tags        = merge(var.sg_extra_tags, local.standard_tags)
  vm_volume_tags = merge(var.volume_extra_tags, local.standard_tags)
  instance_tags  = merge(var.instance_extra_tags, local.standard_tags)
  //if security group name not set take by default ${var.customer}-${var.project}-vm-${var.env}
  security_group_name = var.sg_name != "" ? var.sg_name : "${var.customer}-${var.project}-vm-${var.env}"
}
