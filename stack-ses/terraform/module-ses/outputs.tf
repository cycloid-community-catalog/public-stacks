# SES iam

output "iam_ses_key" {
  value = aws_iam_access_key.ses_smtp_user.id
}

output "iam_ses_secret" {
  value = aws_iam_access_key.ses_smtp_user.secret
}

output "iam_ses_smtp_user_key" {
  value = aws_iam_access_key.ses_smtp_user.id
}

output "iam_ses_smtp_user_secret" {
  value = aws_iam_access_key.ses_smtp_user.ses_smtp_password
}

# workaround to handle count = 0 on output
# https://github.com/hashicorp/terraform/issues/16726
output "aws_sqs_queue_url" {
  value = element(concat(aws_sqs_queue.email_delivery_queue.*.id, [""]), 0)
}

output "elasticache_endpoint" {
  value = aws_elasticache_replication_group.redis-cluster.*.configuration_endpoint_address
}

