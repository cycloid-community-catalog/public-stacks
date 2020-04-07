output "iam_s3_key" {
  value = aws_iam_access_key.s3.id
}

output "iam_s3_secret" {
  value = aws_iam_access_key.s3.secret
}

output "s3_id" {
  value = aws_s3_bucket.s3.id
}

