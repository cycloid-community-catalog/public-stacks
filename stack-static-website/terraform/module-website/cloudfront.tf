#
# App cloudfront
#

resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "website bucket ${aws_s3_bucket.website.id}"
}

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  default_root_object = var.cloudfront_default_root_object
  is_ipv6_enabled     = true
  comment             = "website ${var.project} on ${var.env}"
  aliases             = var.cloudfront_aliases

  price_class = var.cloudfront_price_class

  /*
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }
  */

  viewer_certificate {
    acm_certificate_arn            = var.cloudfront_certificate_arn
    ssl_support_method             = var.cloudfront_certificate_arn == "" ? "" : "sni-only"
    minimum_protocol_version       = var.cloudfront_minimum_protocol_version
    cloudfront_default_certificate = var.cloudfront_certificate_arn == "" ? true : false
  }

  # BUCKET website
  origin {
    domain_name = aws_s3_bucket.website.bucket_domain_name
    origin_id   = "origin-bucket-${aws_s3_bucket.website.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = var.cloudfront_cache_allowed_methods
    cached_methods  = var.cloudfront_cache_cached_methods

    forwarded_values {
      query_string = var.cloudfront_forward_query_string
      headers      = var.cloudfront_forward_headers

      cookies {
        forward = var.cloudfront_forward_cookies
      }
    }

    viewer_protocol_policy = var.cloudfront_viewer_protocol_policy
    default_ttl            = var.cloudfront_default_ttl
    min_ttl                = var.cloudfront_min_ttl
    max_ttl                = var.cloudfront_max_ttl

    target_origin_id = "origin-bucket-${aws_s3_bucket.website.id}"

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_type
      locations        = var.cloudfront_geo_restriction_locations
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.cloudfront_ordered_cache

    content {
      path_pattern = ordered_cache_behavior.value.path_pattern

      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id == "" ? module.this.id : ordered_cache_behavior.value.target_origin_id
      compress         = ordered_cache_behavior.value.compress

      forwarded_values {
        query_string = ordered_cache_behavior.value.forward_query_string
        headers      = ordered_cache_behavior.value.forward_header_values

        cookies {
          forward = ordered_cache_behavior.value.forward_cookies
        }
      }

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      default_ttl            = ordered_cache_behavior.value.default_ttl
      min_ttl                = ordered_cache_behavior.value.min_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_association
        content {
          event_type   = lambda_function_association.value.event_type
          include_body = lookup(lambda_function_association.value, "include_body", null)
          lambda_arn   = lambda_function_association.value.lambda_arn
        }
      }
    }
  }

  tags = merge(local.merged_tags, {
    Name = "${var.project}-${var.env}-website"
  })
}
