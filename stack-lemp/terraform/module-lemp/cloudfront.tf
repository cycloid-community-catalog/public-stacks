#
# App cloudfront
#

resource "aws_cloudfront_origin_access_identity" "medias" {
  count   = var.create_s3_medias && var.create_cloudfront_medias ? 1 : 0
  comment = "medias bucket ${var.env}"
}

resource "aws_cloudfront_distribution" "cdn" {
  count           = var.create_s3_medias && var.create_cloudfront_medias ? 1 : 0
  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.project} cdn on ${var.env} bucket"
  aliases         = var.cloudfront_aliases

  price_class = var.cloudfront_price_class

  custom_error_response {
    error_code            = 404
    error_caching_min_ttl = 0

    #response_code      = 200
    #response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_ssl_certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.cloudfront_minimum_protocol_version
  }

  # BUCKET
  origin {
    domain_name = aws_s3_bucket.medias[0].bucket_domain_name
    origin_id   = "origin-bucket-${aws_s3_bucket.medias[0].id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.medias[0].cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]

    cached_methods = var.cloudfront_cached_methods

    forwarded_values {
      query_string = false

      #headers = ["*"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = var.cloudfront_min_ttl
    default_ttl            = var.cloudfront_default_ttl
    max_ttl                = var.cloudfront_max_ttl
    target_origin_id       = "origin-bucket-${aws_s3_bucket.medias[0].id}"
    viewer_protocol_policy = "allow-all"
    compress               = var.cloudfront_compress
  }


  tags = merge(var.extra_tags, {
    Name = "${var.project}-cloudfront-${var.env}"
    role = "cdn"
  })
}

output "cloudfront_medias_domain_name" {
  value = join("", aws_cloudfront_distribution.cdn.*.domain_name)
}
