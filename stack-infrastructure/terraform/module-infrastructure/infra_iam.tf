# Create IAM users
resource "aws_iam_user" "alerting" {
  name = "alerting${var.suffix}"
  path = "/cycloid/"
}

resource "aws_iam_access_key" "alerting" {
  user = aws_iam_user.alerting.name
}

# SES Full Access
resource "aws_iam_user_policy_attachment" "alerting_ses" {
  user       = aws_iam_user.alerting.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

