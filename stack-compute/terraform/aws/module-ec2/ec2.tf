###
# AMI DATA
###

data "aws_ami" "vm" {
  most_recent = var.ami_most_recent

  filter {
    name   = "name"
    values = [var.ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_virtualisation_type]
  }

  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }

  filter {
    name   = "root-device-type"
    values = [var.ami_root_device_type]
  }

  owners = [var.ami_owners]
}


###
# Cloud init template
###

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.sh.tpl")
  vars = {
    file_content  = var.file_content
  }
}


###
# Security Group
###

resource "aws_security_group" "ec2" {
  name        = local.security_group_name
  description = "Security group for ec2  ${var.project}-${var.env}"
  vpc_id      = var.vpc_id

  ingress = var.sg_ingress_rules
  egress  = var.sg_egress_rules

  tags = local.sg_tags
}

###
# EC2
###

resource "aws_instance" "vm" {
  ami           = data.aws_ami.vm.id
  instance_type = var.instance_type

  // cloud init script - if enabled 
  user_data_base64 = base64encode(data.template_file.user_data.rendered)

  // keypair name - if enabled
  key_name = var.key_name

  //network
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  subnet_id                   = var.subnet_id
  private_ip                  = var.private_ip
  associate_public_ip_address = var.associate_public_ip_address

  //storage
  root_block_device {
    delete_on_termination = var.enable_vm_disk_delete_on_termination
    encrypted             = var.enable_vm_disk_encrypted
    volume_size           = var.vm_disk_size
    volume_type           = var.vm_disk_type
  }
  ebs_optimized = var.ebs_optimized
  volume_tags   = local.vm_volume_tags

  //tags
  tags = local.instance_tags
}