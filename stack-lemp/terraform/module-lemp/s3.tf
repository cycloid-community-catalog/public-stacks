#
# medias
#

data "aws_iam_policy_document" "public_s3_bucket_medias" {
  count = var.create_s3_medias ? 1 : 0

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
      "arn:aws:s3:::${var.customer}-${var.project}-medias-${var.env}/*",
    ]
  }
}

resource "aws_s3_bucket" "medias" {
  count = var.create_s3_medias ? 1 : 0

  bucket = "${var.customer}-${var.project}-medias-${var.env}"
  policy = var.s3_medias_policy_json != "" ? var.s3_medias_policy_json : data.aws_iam_policy_document.public_s3_bucket_medias[0].json
  acl    = var.s3_medias_acl

  tags = merge(var.extra_tags, {
    Name = "${var.customer}-${var.project}-medias-${var.env}"
    role = "medias"
  })

}

#
# IAM
#

# S3 deployment policy
data "aws_iam_policy_document" "s3-medias" {
  count = var.create_s3_medias ? 1 : 0

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.medias[0].id}",
    ]
  }

  statement {
    actions = [
      "s3:*",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.medias[0].id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3-medias" {
  count       = var.create_s3_medias ? 1 : 0
  name        = "${var.project}-${var.env}-s3-medias_access"
  description = "Grant s3 medias access on bucket ${aws_s3_bucket.medias[0].id}"
  policy      = data.aws_iam_policy_document.s3-medias[0].json
}

resource "aws_iam_user" "s3-medias" {
  count = var.create_s3_medias ? 1 : 0
  name  = "s3-medias-${var.project}-${var.env}"
  path  = "/"
}

resource "aws_iam_access_key" "s3-medias" {
  count = var.create_s3_medias ? 1 : 0
  user  = aws_iam_user.s3-medias[0].name
}

resource "aws_iam_user_policy_attachment" "s3-medias_access" {
  count      = var.create_s3_medias ? 1 : 0
  user       = aws_iam_user.s3-medias[0].name
  policy_arn = aws_iam_policy.s3-medias[0].arn
}

resource "aws_iam_role_policy_attachment" "front_medias_access" {
  count      = var.create_s3_medias ? 1 : 0
  role       = aws_iam_role.front.name
  policy_arn = aws_iam_policy.s3-medias[0].arn
}

output "iam_s3-medias_user_key" {
  value = try(aws_iam_access_key.s3-medias[0].id, "")
}

output "iam_s3-medias_user_secret" {
  value = try(aws_iam_access_key.s3-medias[0].secret, "")
}

output "iam_s3-medias_user_name" {
  value = try(aws_iam_user.s3-medias[0].name, "")
}

output "s3_medias" {
  value = try(aws_s3_bucket.medias[0].id, "")
}
