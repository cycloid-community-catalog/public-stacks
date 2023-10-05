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

# Create IAM Role for front
resource "aws_iam_role" "front" {
  name               = "cycloid_${var.project}-${var.env}-front"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/${var.project}/"
}

resource "aws_iam_instance_profile" "front_profile" {
  name = "cycloid_profile-front-${var.project}-${var.env}"
  role = aws_iam_role.front.name
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
  role       = aws_iam_role.front.name
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
      "arn:aws:cloudformation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stack/${var.project}-front-${var.env}/*",
    ]
  }
}

resource "aws_iam_policy" "cloudformation-signal" {
  name        = "${var.env}-${var.project}-cloudformation-signal"
  path        = "/"
  description = "Allow to send stack signal for front"
  policy      = data.aws_iam_policy_document.cloudformation-signal.json
}

resource "aws_iam_role_policy_attachment" "cloudformation-signal" {
  role       = aws_iam_role.front.name
  policy_arn = aws_iam_policy.cloudformation-signal.arn
}

#####################
# Logs
#####################

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
  role       = aws_iam_role.front.name
  policy_arn = aws_iam_policy.push-logs.arn
}

#####################
# Deployment
#####################

# S3 deployment policy
data "aws_iam_policy_document" "s3_bucket_deploy" {
  statement {
    actions = [
      "s3:ListBucketVersions",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetObjectVersion",
      "s3:PutObjectVersionAcl",
      "s3:ListObjectVersions",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.deploy_bucket_name}",
    ]
  }

  statement {
    actions = [
      "s3:ListBucketVersions",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetObjectVersion",
      "s3:PutObjectVersionAcl",
      "s3:ListObjectVersions",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${var.deploy_bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "s3_bucket_deploy" {
  name        = "${var.env}-${var.project}-s3_bucket_deploy"
  path        = "/"
  description = "Get code archive"
  policy      = data.aws_iam_policy_document.s3_bucket_deploy.json
}

resource "aws_iam_role_policy_attachment" "s3_bucket_deploy" {
  role       = aws_iam_role.front.name
  policy_arn = aws_iam_policy.s3_bucket_deploy.arn
}
