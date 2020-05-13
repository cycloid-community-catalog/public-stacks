# Create a bucket for terraform remote state
resource "aws_s3_bucket" "terraform_remote_state" {
  count = var.create_s3_bucket_remote_state ? 1 : 0

  bucket = "${var.customer}-terraform-remote-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = merge(local.merged_tags, {
    Name       = "terraform-remote-state"
  })
}

