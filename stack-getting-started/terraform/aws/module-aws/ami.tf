data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
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

  #"379101102735", # Old debian
  #"136693071363", # Debian10 & debian11
  #"125523088429", # Centos
  #"099720109477", # Ubuntu
}
