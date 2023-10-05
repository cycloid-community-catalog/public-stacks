###
# sns
###

resource "aws_sns_topic" "email_delivery_topic" {
  name = "${var.project}_${var.env}_email_delivery_topic"
}

resource "aws_ses_identity_notification_topic" "bounce_notifications" {
  count             = var.create_sqs ? 1 : 0
  topic_arn         = aws_sns_topic.email_delivery_topic.arn
  notification_type = "Bounce"
  identity          = aws_ses_domain_identity.mail_domain.domain
}

resource "aws_ses_identity_notification_topic" "complaint_notifications" {
  count             = var.create_sqs ? 1 : 0
  topic_arn         = aws_sns_topic.email_delivery_topic.arn
  notification_type = "Complaint"
  identity          = aws_ses_domain_identity.mail_domain.domain
}

# Sns to sqs
resource "aws_sns_topic_subscription" "email_delivery_queue_topic_subscription" {
  count     = var.create_sqs ? 1 : 0
  topic_arn = aws_sns_topic.email_delivery_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.email_delivery_queue[0].arn
}

###
# sns
###

resource "aws_sqs_queue" "email_delivery_queue" {
  count                      = var.create_sqs ? 1 : 0
  name                       = "${var.project}_${var.env}_email_delivery"
  delay_seconds              = 90
  max_message_size           = 2048
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 300

  tags = merge(local.merged_tags, {
    Name         = "${var.project}-sqs-${var.env}"
    role         = "sqs"
  })
}

data "aws_iam_policy_document" "allow_sendmessage" {
  statement {
    actions = ["sqs:SendMessage"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"

      values = [
        aws_sns_topic.email_delivery_topic.arn,
      ]
    }
  }
}

resource "aws_sqs_queue_policy" "allow_sendmessage" {
  count     = var.create_sqs ? 1 : 0
  queue_url = aws_sqs_queue.email_delivery_queue[0].id
  policy    = data.aws_iam_policy_document.allow_sendmessage.json
}

