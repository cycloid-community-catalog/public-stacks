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

  owners = ["379101102735"] # Debian
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
