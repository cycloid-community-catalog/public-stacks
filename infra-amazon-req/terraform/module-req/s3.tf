locals {
  infra_iam_user_arn = "${var.infra_iam_arn != "" ? var.infra_iam_arn : join("", aws_iam_user.infra.*.arn)}"
}

data "aws_iam_policy_document" "infra_access_to_s3_remote_state" {
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${local.infra_iam_user_arn}"]
    }
  }
}

resource "aws_s3_bucket" "terraform_remote_state" {
  count = "${var.create_s3_bucket ? 1 : 0}"

  bucket        = "${var.bucket_name}"
  acl           = "private"
  force_destroy = "${var.force_destroy}"

  versioning {
    enabled = true
  }

  tags {
    Name       = "${var.bucket_name}"
    client     = "${var.customer}"
    project    = "${var.project}"
    env        = "${var.env}"
    cycloid.io = "true"
  }

  policy = "${data.aws_iam_policy_document.infra_access_to_s3_remote_state.json}"
}
