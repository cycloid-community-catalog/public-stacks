resource "aws_iam_user" "ses_smtp_user" {
  name = "ses-smtp-user${var.suffix}"
  path = "/cycloid/"
}

resource "aws_iam_access_key" "ses_smtp_user" {
  user = aws_iam_user.ses_smtp_user.name
}

data "aws_iam_policy_document" "ses_sending_access" {
  statement {
    effect    = "Allow"
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ses_sending_access" {
  name   = "ses-sending-access${var.suffix}"
  path   = "/cycloid/"
  policy = data.aws_iam_policy_document.ses_sending_access.json
}

resource "aws_iam_user_policy_attachment" "ses_sending_access" {
  user       = aws_iam_user.ses_smtp_user.name
  policy_arn = aws_iam_policy.ses_sending_access.arn
}

