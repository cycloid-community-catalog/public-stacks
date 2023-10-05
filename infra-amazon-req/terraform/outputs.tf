output "req_codecommit_ro_user_id" {
  value       = "${module.req.codecommit_ro_user_id}"
  description = "Codecommit dedicated user ID"
}

output "req_codecommit_ro_user_arn" {
  value       = "${module.req.codecommit_ro_user_arn}"
  description = "Codecommit dedicated user ARN"
}

output "req_codecommit_username" {
  value       = "${module.req.codecommit_username}"
  description = "Codecommit dedicated user Username"
}

output "req_codecommit_readonly_username" {
  value       = "${module.req.codecommit_readonly_username}"
  description = "Codecommit dedicated RO user Username"
}

output "req_codecommit_repository_id" {
  value       = "${module.req.codecommit_repository_id}"
  description = "The ID of the repository"
}

output "req_remote_state_bucket_name" {
  value       = "${module.req.remote_state_bucket_name}"
  description = "The name of the bucket"
}

output "req_infra_user_id" {
  value       = "${module.req.infra_user_id}"
  descroption = "IAM infra user ID"
}

output "req_infra_user_arn" {
  value       = "${module.req.infra_user_arn}"
  descroption = "IAM infra user ARN"
}
