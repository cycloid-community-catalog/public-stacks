locals {
  backup_bucket_prefix = var.backup_bucket_prefix == "" ? "${var.customer}-" : var.backup_bucket_prefix
}

data "aws_iam_policy_document" "s3_backup" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${local.backup_bucket_prefix}backup/*",
      "arn:aws:s3:::${local.backup_bucket_prefix}backup",
    ]
  }
}

resource "aws_iam_policy" "s3_backup" {
  name   = "s3-backup${var.suffix}"
  path   = "/cycloid/"
  policy = data.aws_iam_policy_document.s3_backup.json
}

resource "aws_iam_role_policy_attachment" "infra_backup" {
  role       = aws_iam_role.infra.name
  policy_arn = aws_iam_policy.s3_backup.arn
}

resource "aws_s3_bucket" "backup" {
  bucket = "${local.backup_bucket_prefix}backup"
  acl    = "private"

  lifecycle {
    ignore_changes = [lifecycle_rule]
  }

  tags = merge(local.merged_tags, {
    Name       = "${local.backup_bucket_prefix}backup"
  })
}

// Expose iam policy for backups
output "iam_policy_backup" {
  value = aws_iam_policy.s3_backup.arn
}

resource "aws_iam_user" "backup" {
  count = var.create_backup_user ? 1 : 0

  name = "backup${var.suffix}"
  path = "/cycloid/"
}

resource "aws_iam_access_key" "backup" {
  count = var.create_backup_user ? 1 : 0
  user  = aws_iam_user.backup[0].name
}

resource "aws_iam_user_policy_attachment" "backup_s3_access" {
  count      = var.create_backup_user ? 1 : 0
  user       = aws_iam_user.backup[0].name
  policy_arn = aws_iam_policy.s3_backup.arn
}

output "iam_backup_user_key" {
  value = aws_iam_access_key.backup[0].id
}

output "iam_backup_user_secret" {
  value = aws_iam_access_key.backup[0].secret
}

