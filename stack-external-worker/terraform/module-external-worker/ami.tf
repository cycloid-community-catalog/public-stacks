data "aws_ami" "worker" {
  count = var.worker_ami_id == "" ? 1 : 0

  most_recent = true

  filter {
    name   = "name"
    values = ["${var.project}_worker_${var.env}_*"]
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
  image_id = var.worker_ami_id != "" ? var.worker_ami_id : element(data.aws_ami.worker.*.id, 0)
}
