output "keypair_name" {
  value = var.keypair_name != "" ? var.keypair_name : "${var.customer}-${var.project}${var.suffix}"
}

output "bastion_ip" {
  value = aws_eip.bastion.*.public_ip
}

output "bastion_sg" {
  value = aws_security_group.bastion[0].id
}

output "iam_ses_smtp_user_key" {
  value = aws_iam_access_key.ses_smtp_user.id
}

output "iam_ses_smtp_user_secret" {
  value = aws_iam_access_key.ses_smtp_user.ses_smtp_password_v4
}

output "deployment_bucket_name" {
  value = aws_s3_bucket.deployment.id
}

output "zones" {
  value = local.aws_availability_zones
}

