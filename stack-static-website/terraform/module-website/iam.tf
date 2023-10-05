resource "aws_iam_user" "s3" {
  name = "s3-${var.project}-${var.env}"
  path = "/"
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}

resource "aws_iam_policy_attachment" "s3_access" {
  name       = "${aws_s3_bucket.website.id}_access"
  users      = [aws_iam_user.s3.name]
  policy_arn = aws_iam_policy.s3_access.arn
}

#
# IAM access
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
      "arn:aws:s3:::${aws_s3_bucket.website.id}",
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
      "arn:aws:s3:::${aws_s3_bucket.website.id}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_access" {
  name        = "s3_${aws_s3_bucket.website.id}_access"
  description = "Grant s3 access on bucket on ${aws_s3_bucket.website.id}"
  policy      = data.aws_iam_policy_document.s3_access.json
}
