resource "aws_iam_user" "infra" {
  count = var.create_infra_user ? 1 : 0

  name = "infra${var.suffix}"
  path = "/cycloid/"
}

resource "aws_iam_access_key" "infra" {
  count = var.create_infra_user ? 1 : 0
  user  = aws_iam_user.infra[0].name
}

resource "aws_iam_user_policy_attachment" "infra_administrator_access_user" {
  count      = var.create_infra_user ? 1 : 0
  user       = aws_iam_user.infra[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "infra_administrator_access_role" {
  count      = var.create_infra_user ? 1 : 0
  role       = "admin"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "infra_administrator_access_extra_users" {
  count      = length(var.extra_admin_users)
  user       = element(var.extra_admin_users, count.index)
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy_document" "role_infra" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "infra" {
  name               = "infra${var.suffix}"
  assume_role_policy = data.aws_iam_policy_document.role_infra.json
}

resource "aws_iam_user_policy_attachment" "infra_readonly_user" {
  count      = length(var.readonly_users)
  user       = element(var.readonly_users, count.index)
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "infra_readonly_group" {
  count      = length(var.readonly_groups)
  group      = element(var.readonly_groups, count.index)
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "infra_readonly_role" {
  role       = aws_iam_role.infra.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy_document" "infra_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

data "aws_iam_policy_document" "infa_ec2_snap" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteSnapshot",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "infra_logs" {
  name   = "infra-logs${var.suffix}"
  path   = "/cycloid/"
  policy = data.aws_iam_policy_document.infra_logs.json
}

resource "aws_iam_policy" "infa_ec2_snap" {
  name   = "infra-ec2-snap${var.suffix}"
  path   = "/cycloid/"
  policy = data.aws_iam_policy_document.infa_ec2_snap.json
}

resource "aws_iam_role_policy_attachment" "infra_logs" {
  role       = aws_iam_role.infra.name
  policy_arn = aws_iam_policy.infra_logs.arn
}

resource "aws_iam_role_policy_attachment" "infa_ec2_snap" {
  role       = aws_iam_role.infra.name
  policy_arn = aws_iam_policy.infa_ec2_snap.arn
}

resource "aws_iam_instance_profile" "infra" {
  name = "infra${var.suffix}"
  role = aws_iam_role.infra.name
}

// Expose iam policy for pushing logs
output "iam_policy_infra-logs" {
  value = aws_iam_policy.infra_logs.arn
}

