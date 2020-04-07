###
# ses
###
resource "aws_ses_domain_identity" "mail_domain" {
  domain = var.mail_domain
}

