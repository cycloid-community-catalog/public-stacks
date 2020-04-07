resource "aws_security_group" "jenkins" {
  name        = "${var.project}-jenkins-${var.env}"
  description = "jenkins ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.merged_tags, {
    Name = "${var.project}-jenkins-${var.env}"
    role = "jenkins"
  })
}

resource "aws_security_group_rule" "any_to_http" {
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins.id
}

resource "aws_security_group_rule" "bastion_to_jenkins_ssh" {
  count                    = var.bastion_sg_allow != "" ? 1 : 0
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_sg_allow
  security_group_id        = aws_security_group.jenkins.id
}

resource "random_shuffle" "jenkins_subnet_id" {
  input        = var.public_subnets_ids
  result_count = 1
}

resource "aws_instance" "jenkins" {
  ami = data.aws_ami.debian.id

  instance_type        = var.jenkins_type
  key_name             = var.keypair_name
  ebs_optimized        = var.jenkins_ebs_optimized

  vpc_security_group_ids = compact([var.bastion_sg_allow, aws_security_group.jenkins.id])
  subnet_id              = random_shuffle.jenkins_subnet_id.result[0]

  root_block_device {
    volume_size           = var.jenkins_disk_size
    volume_type           = var.jenkins_disk_type
    delete_on_termination = true
  }

  volume_tags = merge(local.merged_tags, {
    Name = "${var.project}-jenkins-${var.env}"
    role = "jenkins"
  })

  tags = merge(local.merged_tags, {
    Name = "${var.project}-jenkins-${var.env}"
    role = "jenkins"
  })
}
