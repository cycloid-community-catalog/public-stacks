# Codecommit repositories
output "codecommit_ro_user_id" {
  value = "${aws_iam_user.codecommit_readonly.*.user_id}"
}

output "codecommit_ro_user_arn" {
  value = "${aws_iam_user.codecommit_readonly.*.user_arn}"
}

output "codecommit_username" {
  value = "${aws_iam_user_ssh_key.admin.*.ssh_public_key_id}"
}

output "codecommit_readonly_username" {
  value = "${aws_iam_user_ssh_key.codecommit_readonly.*.ssh_public_key_id}"
}

output "codecommit_repository_id" {
  value = "${aws_codecommit_repository.repository.*.id}"
}

# S3 remote state bucket
output "remote_state_bucket_name" {
  value = "${aws_s3_bucket.terraform_remote_state.*.id}"
}

# IAM infra user
output "infra_user_id" {
  value = "${aws_iam_user.infra.*.user_id}"
}

output "infra_user_arn" {
  value = "${aws_iam_user.infra.*.user_arn}"
}
