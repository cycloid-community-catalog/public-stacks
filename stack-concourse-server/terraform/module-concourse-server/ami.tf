data "aws_ami" "concourse" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.project}_concourse-server_${var.env}_*"]
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
