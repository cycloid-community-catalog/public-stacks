resource "aws_s3_bucket" "deployment" {
  bucket = "${var.customer}-deployment"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 90
    }
  }

  tags = merge(local.merged_tags, {
    Name       = "deployment"
  })
}

# S3 deployment policy
data "aws_iam_policy_document" "s3-deployment" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
      "s3:GetBucketVersioning",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.deployment.id}",
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
      "arn:aws:s3:::${aws_s3_bucket.deployment.id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3-deployment" {
  name        = "deployment_access"
  description = "Grant s3 access on bucket ${aws_s3_bucket.deployment.id}"
  policy      = data.aws_iam_policy_document.s3-deployment.json
}

output "iam_policy_s3-deployment" {
  value = aws_iam_policy.s3-deployment.arn
}

