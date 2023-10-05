resource "aws_iam_user" "s3" {
  name = "s3-${var.project}-${var.env}"
  path = "/"
}

resource "aws_iam_access_key" "s3" {
  user = aws_iam_user.s3.name
}

resource "aws_iam_policy_attachment" "s3_access" {
  name       = "${var.bucket_name}_access"
  users      = [aws_iam_user.s3.name]
  policy_arn = aws_iam_policy.s3_access.arn
}

