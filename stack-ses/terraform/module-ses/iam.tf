#
# Policies
#

# Create IAM users
resource "aws_iam_user" "ses_smtp_user" {
  name = "${var.project}-${var.env}-ses_smtp_user"
  path = "/${var.project}/"
}

resource "aws_iam_access_key" "ses_smtp_user" {
  user = aws_iam_user.ses_smtp_user.name
}

# SES Full Access
resource "aws_iam_user_policy_attachment" "email_ses" {
  user       = aws_iam_user.ses_smtp_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "sqs_access" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:*"]
    resources = ["arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.project}_${var.env}_email_delivery"]
  }
}

resource "aws_iam_policy" "sqs_access" {
  count  = var.create_sqs ? 1 : 0
  name   = "${var.project}-${var.env}-sqs-access"
  path   = "/${var.project}/"
  policy = data.aws_iam_policy_document.sqs_access.json
}

resource "aws_iam_user_policy_attachment" "sqs_access" {
  count      = var.create_sqs ? 1 : 0
  user       = aws_iam_user.ses_smtp_user.name
  policy_arn = aws_iam_policy.sqs_access[0].arn
}

