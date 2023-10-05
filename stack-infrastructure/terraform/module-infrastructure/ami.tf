data "aws_ami" "debian_stretch" {
  filter {
    name   = "name"
    values = ["debian-stretch-*"]
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

  #filter {
  #  name   = "image-id"
  #  values = ["ami-fe4b3287"]
  #}

  most_recent = true
  owners      = ["379101102735"] # Debian
}

