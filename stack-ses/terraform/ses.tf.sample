module "ses" {
  #####################################
  # Do not modify the following lines #
  source      = "./module-ses"
  project     = var.project
  env         = var.env
  customer    = var.customer
  #####################################

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id                   = "<vpc-id>"

  #. mail_domain (required):
  #+ Domain used for emailing
  mail_domain = "example.com"

  #. create_sqs (optional, bool): false
  #+ If you need to create a sqs (for example used for bounce emails)

  #. create_elasticache (optional, bool): false
  #+ If you need to create an elasticache (for example used for sending/queing emails)

  #. elasticache_security_groups (optional, list): []
  #+ Those security groups will be granted access to the elasticache cluster

  #. elasticache_subnet_group_name (optional): redis
  #+ Name of an Amazon elasticache subnet group to use

  #. elasticache_type (optional): cache.t2.micro
  #+ Instance type to use for the elasticache cluster
  
  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources.
  #extra_tags = { "foo" = "bar" }

}

# If you desire create a R53 record for the redis
# resource "aws_route53_record" "redis" {
#   zone_id = "xxxx"
#   name    = "xxxx"
#   type    = "CNAME"
#   ttl     = "3600"
#   records = ["${modue.ses.elasticache_endpoint}"]
# }
