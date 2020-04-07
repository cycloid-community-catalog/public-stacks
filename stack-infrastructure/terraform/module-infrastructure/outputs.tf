output "keypair_name" {
  value = "${var.keypair_name != "" ? "${var.keypair_name}" : "${var.customer}-${var.project}${var.suffix}"}"
}

output "bastion_ip" {
  value = ["${aws_eip.bastion.*.public_ip}"]
}

output "iam_ses_smtp_user_key" {
  value = "${aws_iam_access_key.ses_smtp_user.id}"
}

output "iam_ses_smtp_user_secret" {
  value = "${aws_iam_access_key.ses_smtp_user.ses_smtp_password}"
}

output "deployment_bucket_name" {
  value = "${aws_s3_bucket.deployment.id}"
}

output "zones" {
  value = "${var.zones}"
}
