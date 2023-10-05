###

# S3

###

resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name
  acl    = var.bucket_acl

  versioning {
    enabled = var.versioning_enabled
  }

  tags = merge(local.merged_tags, {
    Name = "${var.customer}-${var.project}-s3-${var.env}"
  })
}

#
# IAM
#

data "aws_iam_policy_document" "s3_access" {
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetObjectVersion",
      "s3:PutObjectVersionAcl",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3.id}",
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetObjectVersion",
      "s3:PutObjectVersionAcl",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3.id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name        = "s3_${var.bucket_name}_access"
  description = "Grant s3 access on bucket on ${aws_s3_bucket.s3.id}"
  policy      = data.aws_iam_policy_document.s3_access.json
}

