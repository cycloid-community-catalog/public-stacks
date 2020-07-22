# See the variables.tf file in module- for a complete description
# of the options

module "s3" {

  #####################################
  # Do not modify the following lines #
  source = "./module-s3"

  project  = var.project
  env      = var.env
  customer = var.customer
  #####################################

  #. bucket_name (required):
  #+ Name of the S3 bucket to create. Only lowercase alphanumeric characters and hyphens allowed.
  bucket_name              = "<bucket name>"

  #. bucket_acl (optional): private
  #+ S3 canned ACL: https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl

  #. versioning_enabled (optional, bool): false
  #+ Enable S3 bucket versionning.

  #. extra_tags(optional, dict): {}
  #+ Dict of extra tags to add on aws resources..
}
