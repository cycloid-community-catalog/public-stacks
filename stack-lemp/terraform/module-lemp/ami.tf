data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.debian_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = [
    "379101102735",
    "136693071363",
    "125523088429",
    "099720109477",
  ]

  #"379101102735", # old debian
  #"136693071363", # debian10 & debian11
  #"125523088429", # centos
  #"099720109477", # Ubuntu
}

data "aws_ami" "front" {
  count       = var.front_ami_id == "" ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.customer}_${var.project}_front_${var.env}_*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["self"]
}

locals {
  image_id = var.front_ami_id != "" ? var.front_ami_id : element(data.aws_ami.front.*.id, 0)
}
