resource "aws_security_group" "front" {
  name        = local.name_prefix

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

# IAM instance profile used with AWS SSM Agent

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create IAM Role for instance
resource "aws_iam_role" "instance" {
  name               = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/${var.project}/"
}

resource "aws_iam_role_policy_attachment" "instance-ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.instance.name
}

resource "aws_iam_instance_profile" "instance" {
  name = local.name_prefix
  role = aws_iam_role.instance.name
}

resource "aws_instance" "front" {
  ami                  = data.aws_ami.debian.id
  iam_instance_profile = aws_iam_instance_profile.instance.name
  user_data = templatefile("${path.module}/userdata.sh.tpl", {
    password = random_string.password.result
  })
  associate_public_ip_address = true
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.front.id]

  tags = {
    Name = local.name_prefix
  }
}
