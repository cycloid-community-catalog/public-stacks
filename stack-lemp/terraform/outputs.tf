output "alb_front_dns_name" {
  value       = module.lemp.alb_front_dns_name
  description = "DNS name of the front ALB."
}

output "alb_front_zone_id" {
  value       = module.lemp.alb_front_zone_id
  description = "Zone ID of the front ALB."
}

output "elasticache_address" {
  value       = module.lemp.elasticache_address
  description = "Address of the ElastiCache."
}

output "elasticache_cluster_id" {
  value       = module.lemp.elasticache_cluster_id
  description = "Cluster Id of the ElastiCache."
}

output "rds_address" {
  value       = module.lemp.rds_address
  description = "Address of the RDS database."
}

output "rds_port" {
  value       = module.lemp.rds_port
  description = "Port of the RDS database."
}

output "rds_username" {
  value       = module.lemp.rds_username
  description = "Username of the RDS database."
}

output "rds_database" {
  value       = module.lemp.rds_database
  description = "Database name of the RDS database."
}

output "iam_s3-medias_user_key" {
  value       = module.lemp.iam_s3-medias_user_key
  description = "Access key of the dedicated IAM user to access to the media S3 bucket."
}

output "iam_s3-medias_user_secret" {
  value       = module.lemp.iam_s3-medias_user_secret
  description = "Access secret key of the dedicated IAM user to access to the media S3 bucket."
}

output "iam_s3-medias_user_name" {
  value       = module.lemp.iam_s3-medias_user_name
  description = "Iam user name of the dedicated IAM user to access to the media S3 bucket."
}

output "s3_medias" {
  value       = module.lemp.s3_medias
  description = "S3 bucket name dedicated to medias."
}

output "iam_ses_user_key" {
  value       = module.lemp.iam_ses_user_key
  description = "Iam user key for SES."
}

output "iam_ses_user_secret" {
  value       = module.lemp.iam_ses_user_secret
  description = "Iam user secret for SES."
}

output "iam_ses_smtp_user_key" {
  value       = module.lemp.iam_ses_smtp_user_key
  description = "Smtp user key for ses."
}

output "iam_ses_smtp_user_secret" {
  value       = module.lemp.iam_ses_smtp_user_secret
  description = "Smtp user secret for ses."
}

output "cloudfront_medias_domain_name" {
  value       = module.lemp.cloudfront_medias_domain_name
  description = "Cloudfront domain on top of S3 medias bucket."
}
