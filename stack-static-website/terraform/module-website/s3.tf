###

# S3

###

locals {
  s3_policy      = var.s3_policy != "" ? var.s3_policy : data.aws_iam_policy_document.public_s3_bucket.json
  s3_bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : "${var.customer}-${var.project}-s3-${var.env}"
}

resource "aws_s3_bucket" "website" {
  bucket = local.s3_bucket_name
  policy = local.s3_policy
  acl    = var.s3_bucket_acl

  versioning {
    enabled = var.s3_versioning_enabled
  }

  website {
    index_document = var.s3_website_index_document
    error_document = var.s3_website_error_document
  }

  dynamic "cors_rule" {
    for_each = distinct(compact(concat(var.cors_allowed_origins, var.cloudfront_aliases)))
    content {
      allowed_headers = var.cors_allowed_headers
      allowed_methods = var.cors_allowed_methods
      allowed_origins = [cors_rule.value]
      expose_headers  = var.cors_expose_headers
      max_age_seconds = var.cors_max_age_seconds
    }
  }

  tags = merge(local.merged_tags, {
    Name = local.s3_bucket_name
  })
}

data "aws_iam_policy_document" "public_s3_bucket" {
  statement {
    sid = "PublicReadAccess"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}/*",
    ]
  }
}
