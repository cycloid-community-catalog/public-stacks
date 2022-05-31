resource "aws_security_group" "cycloidio_website_albfront_staging" {
  tags = {
    Name                 = "cycloidio-website-albfront-staging"
    client               = "cycloid"
    "cycloid.io"         = "true"
    env                  = "staging"
    monitoring_discovery = "false"
    project              = "cycloidio-website"
    role                 = "front"
  }

  tags_all = {
    Name                 = "cycloidio-website-albfront-staging"
    client               = "cycloid"
    "cycloid.io"         = "true"
    env                  = "staging"
    monitoring_discovery = "false"
    project              = "cycloidio-website"
    role                 = "front"
  }

  description = var.aws_security_group_cycloidio_website_albfront_staging_description
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  name   = var.aws_security_group_cycloidio_website_albfront_staging_name
  vpc_id = var.aws_security_group_cycloidio_website_albfront_staging_vpc_id
}

resource "aws_security_group" "cycloidio_website_front_staging" {
  tags = {
    Name                 = "cycloidio-website-front-staging"
    client               = "cycloid"
    "cycloid.io"         = "true"
    env                  = "staging"
    monitoring_discovery = "false"
    project              = "cycloidio-website"
    role                 = "front"
  }

  tags_all = {
    Name                 = "cycloidio-website-front-staging"
    client               = "cycloid"
    "cycloid.io"         = "true"
    env                  = "staging"
    monitoring_discovery = "false"
    project              = "cycloidio-website"
    role                 = "front"
  }

  description = var.aws_security_group_cycloidio_website_front_staging_description
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    security_groups = ["sg-01d1db19d2e876ce2"]
    to_port         = 80
  }

  name   = var.aws_security_group_cycloidio_website_front_staging_name
  vpc_id = var.aws_security_group_cycloidio_website_front_staging_vpc_id
}

