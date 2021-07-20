resource "aws_security_group" "front" {
  name        = "${var.customer}-${var.project}-${var.env}"
  description = "Front ${var.env} for ${var.project}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
}

resource "random_string" "password" {
  length           = 16
  min_upper        = 1 
  min_lower        = 1 
  min_numeric      = 1 
  min_special      = 1 
  special          = true
  override_special = "_%@"
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh.tpl")

  vars = {
    password        = random_string.password.result
    env             = var.env
    project         = var.project
  }
}

resource "aws_instance" "front" {
  ami                         = data.aws_ami.debian.id
  user_data_base64            = base64encode(data.template_file.user_data.rendered)
  associate_public_ip_address = true
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.front.id]

  tags = {
    Name         = "${var.customer}-${var.project}-front-${var.env}"
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    customer     = var.customer
  }
}
