output "iam_s3_key" {
  value       = module.s3.iam_s3_key
  description = "IAM access key dedicated to the S3 bucket access"
}

output "iam_s3_secret" {
  value       = module.s3.iam_s3_secret
  description = "IAM secret key dedicated to the S3 bucket access."
}

output "s3_id" {
  value       = module.s3.s3_id
  description = "S3 bucket name."
}

