variable "env" {
}

variable "project" {
  default = "s3"
}

variable "customer" {
}

variable "extra_tags" {
  default = {}
}


locals {
  standard_tags = {
    client       = var.customer
    env          = var.env
    project      = var.project
    "cycloid.io" = "true"
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}

####
# S3
####

variable "s3_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket"
}

variable "s3_website_index_document" {
  type        = string
  default     = "index.html"
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders"
}
variable "s3_website_error_document" {
  type        = string
  default     = ""
  description = "An absolute path to the document to return in case of a 4XX error"
}

variable "s3_bucket_acl" {
  default = "private"
}

variable "s3_policy" {
  default = ""
}

variable "s3_versioning_enabled" {
  type        = bool
  default     = false
  description = "When true, the access logs bucket will be versioned"
}

variable "cors_allowed_headers" {
  type        = list(string)
  default     = ["*"]
  description = "List of allowed headers for S3 bucket"
}

variable "cors_allowed_methods" {
  type        = list(string)
  default     = ["GET"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for S3 bucket"
}

variable "cors_allowed_origins" {
  type        = list(string)
  default     = []
  description = "List of allowed origins (e.g. example.com, test.com) for S3 bucket"
}

variable "cors_expose_headers" {
  type        = list(string)
  default     = ["ETag"]
  description = "List of expose header in the response for S3 bucket"
}

variable "cors_max_age_seconds" {
  type        = number
  default     = 3600
  description = "Time in seconds that browser can cache the response for S3 bucket"
}

####
# Cloudfront
####

variable "cloudfront_aliases" {
  type        = list(string)
  description = "List of FQDN's - Used to set the Alternate Domain Names (CNAMEs) setting on Cloudfront"
  default     = []
}

variable "cloudfront_certificate_arn" {
  default = ""
}

variable "cloudfront_price_class" {
  type        = string
  default     = "PriceClass_200"
  description = "Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
}

variable "cloudfront_default_root_object" {
  default = "index.html"
}

variable "cloudfront_minimum_protocol_version" {
  type        = string
  description = "Cloudfront TLS minimum protocol version"
  default     = "TLSv1"
}

variable "cloudfront_cache_allowed_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront"
}

variable "cloudfront_cache_cached_methods" {
  type        = list(string)
  default     = ["GET", "HEAD"]
  description = "List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD)"
}

variable "cloudfront_forward_query_string" {
  type        = bool
  default     = true
  description = "Forward query strings to the origin that is associated with this cache behavior"
}

variable "cloudfront_forward_headers" {
  type        = list(string)
  description = "A list of whitelisted header values to forward to the origin"
  default     = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
}

variable "cloudfront_forward_cookies" {
  type        = string
  default     = "none"
  description = "Specifies whether you want CloudFront to forward all or no cookies to the origin. Can be 'all' or 'none'"
}

variable "cloudfront_viewer_protocol_policy" {
  type        = string
  description = "allow-all, redirect-to-https"
  default     = "redirect-to-https"
}

variable "cloudfront_default_ttl" {
  default     = 300
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "cloudfront_min_ttl" {
  default     = 0
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
}

variable "cloudfront_max_ttl" {
  default     = 604800
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
}

variable "cloudfront_ordered_cache" {
  type = list(object({
    target_origin_id = string
    path_pattern     = string

    allowed_methods = list(string)
    cached_methods  = list(string)
    compress        = bool

    viewer_protocol_policy = string
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number

    forward_query_string  = bool
    forward_header_values = list(string)
    forward_cookies       = string

    lambda_function_association = list(object({
      event_type   = string
      include_body = bool
      lambda_arn   = string
    }))
  }))
  default     = []
  description = "An ordered list of cache behaviors resource for this distribution"
}

variable "lambda_function_association" {
  type = list(object({
    event_type   = string
    include_body = bool
    lambda_arn   = string
  }))

  description = "A config block that triggers a lambda function with specific actions"
  default     = []
}

variable "cloudfront_geo_restriction_type" {
  type = string

  # e.g. "whitelist"
  default     = "none"
  description = "Method that use to restrict distribution of your content by country: `none`, `whitelist`, or `blacklist`"
}

variable "cloudfront_geo_restriction_locations" {
  type = list(string)

  # e.g. ["US", "CA", "GB", "DE"]
  default     = []
  description = "List of country codes for which  CloudFront either to distribute content (whitelist) or not distribute your content (blacklist)"
}
