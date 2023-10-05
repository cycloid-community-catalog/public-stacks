output "iam_policy_infra-backup" {
  description = "IAM read and write policy to the S3 backup bucket"
  value       = module.infrastructure.iam_policy_backup
}

output "iam_policy_infra-logs" {
  description = "IAM write policy to AWS Cloudwatch logs"
  value       = module.infrastructure.iam_policy_infra-logs
}

output "deployment_bucket_name" {
  description = "S3 bucket name for the deployment bucket"
  value       = module.infrastructure.deployment_bucket_name
}

output "iam_policy_s3-deployment" {
  description = "IAM read and write policy to the S3 deployment bucket"
  value       = module.infrastructure.iam_policy_s3-deployment
}

output "zones" {
  description = "AWS availability zones used"
  value       = module.infrastructure.zones
}

