# Cycloid variables
variable "cyorg" {}
variable "cypro" {}
variable "cyenv" {}
variable "cycom" {}

# AWS variables
variable "aws_cred" {
  description = "Contains AWS access_key and secret_key"
}
variable "aws_region" {
  description = "AWS region where to create servers."
  default     = "eu-west-1"
}