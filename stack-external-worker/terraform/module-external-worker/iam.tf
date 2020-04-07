data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create IAM Role for worker
resource "aws_iam_role" "worker" {
  name               = "worker-${var.project}-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/${var.project}/"
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "profile-worker-${var.project}-${var.env}"
  role = aws_iam_role.worker.name
}

#
# ec2 tag list policy
#
data "aws_iam_policy_document" "ec2-tag-describe" {
  statement {
    actions = [
      "ec2:DescribeTags",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2-tag-describe" {
  name        = "${var.env}-${var.project}-ec2-tag-describe"
  path        = "/"
  description = "EC2 tags Read only"
  policy      = data.aws_iam_policy_document.ec2-tag-describe.json
}

resource "aws_iam_role_policy_attachment" "ec2-tag-describe" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.ec2-tag-describe.arn
}

#
# cloudformation signal-resource allow to send signal to cloudworker stack
#
#Get the account id to generate the policy
data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "cloudformation-signal" {
  statement {
    actions = [
      "cloudformation:SignalResource",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:cloudformation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stack/${var.project}-worker-${var.env}/*",
    ]
  }
}

resource "aws_iam_policy" "cloudformation-signal" {
  name        = "${var.env}-${var.project}-cloudformation-signal"
  path        = "/"
  description = "Allow to send stack signal for worker"
  policy      = data.aws_iam_policy_document.cloudformation-signal.json
}

resource "aws_iam_role_policy_attachment" "cloudformation-signal" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.cloudformation-signal.arn
}

#
# policy
#

data "aws_iam_policy_document" "workers" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "workers" {
  name   = "${var.env}-${var.project}-workers"
  path   = "/"
  policy = data.aws_iam_policy_document.workers.json
}

resource "aws_iam_role_policy_attachment" "workers" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.workers.arn
}

# Logs
data "aws_iam_policy_document" "push-logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:UntagLogGroup",
      "logs:TagLogGroup",
      "logs:PutRetentionPolicy",
      "logs:PutLogEvents",
      "logs:DeleteRetentionPolicy",
      "logs:CreateLogStream",
    ]

    resources = ["arn:aws:logs:*:*:log-group:${var.project}_${var.env}:*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:ListTagsLogGroup",
      "logs:DescribeSubscriptionFilters",
      "logs:DescribeMetricFilters",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:TestMetricFilter",
      "logs:DescribeResourcePolicies",
      "logs:DescribeExportTasks",
      "logs:DescribeDestinations",
      "logs:CreateLogGroup",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "push-logs" {
  name        = "${var.env}-${var.project}-push-logs"
  path        = "/"
  description = "Push log to cloudwatch"
  policy      = data.aws_iam_policy_document.push-logs.json
}

resource "aws_iam_role_policy_attachment" "push-logs" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.push-logs.arn
}
