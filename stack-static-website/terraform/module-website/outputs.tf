output "iam_s3_key" {
  value       = aws_iam_access_key.s3.id
  description = "IAM key to access AWS S3 bucket"
}

output "iam_s3_secret" {
  value       = aws_iam_access_key.s3.secret
  description = "IAM secret to access AWS S3 bucket"
}

output "s3_id" {
  value       = aws_s3_bucket.website.id
  description = "ID of AWS S3 bucket"
}

output "cf_id" {
  value       = aws_cloudfront_distribution.website.id
  description = "ID of AWS CloudFront distribution"
}

output "cf_domain_name" {
  value       = aws_cloudfront_distribution.website.domain_name
  description = "Domain name of AWS CloudFront distribution"
}
