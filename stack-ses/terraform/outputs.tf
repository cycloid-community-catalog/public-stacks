# SES iam
output "iam_ses_key" {
  value       = module.ses.iam_ses_key
  description = "Dedicated IAM access key for SES"
}

output "iam_ses_secret" {
  value       = module.ses.iam_ses_secret
  description = "Dedicated IAM secret key for SES"
}

output "iam_ses_smtp_user_key" {
  value       = module.ses.iam_ses_smtp_user_key
  description = "Dedicated SES SMTP key"
}

output "iam_ses_smtp_user_secret" {
  value       = module.ses.iam_ses_smtp_user_secret
  description = "Dedicated SES SMTP secret"
}

# sqs
output "aws_sqs_queue_url" {
  value       = module.ses.aws_sqs_queue_url
  description = "Aws SQS queue URL"
}

# elsticache
output "elasticache_endpoint" {
  value       = module.ses.elasticache_endpoint
  description = "Aws elasticache endpoint"
}

