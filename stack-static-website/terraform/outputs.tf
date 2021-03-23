output "iam_s3_key" {
  value       = module.website.iam_s3_key
  description = "IAM key to access AWS S3 bucket"
}

output "iam_s3_secret" {
  value       = module.website.iam_s3_secret
  description = "IAM secret to access AWS S3 bucket"
}

output "s3_id" {
  value       = module.website.s3_id
  description = "ID of AWS S3 bucket"
}

output "cf_id" {
  value       = module.website.cf_id
  description = "ID of AWS CloudFront distribution"
}

output "cf_domain_name" {
  value       = module.website.cf_domain_name
  description = "Domain name of AWS CloudFront distribution"
}
