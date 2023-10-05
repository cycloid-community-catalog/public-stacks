module "elk" {

  #####################################
  # Do not modify the following lines #
  source = "./module-elk"

  project  = var.project
  env      = var.env
  customer = var.customer
  #####################################

  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id                   = "<vpc-id>"

  #. subnet_ids (required, list):
  #+ Subnets to use for Amazon elasticsearch
  subnet_ids               = ["<subnet-ids>"]

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources. format { "foo" = "bar" }.

  #. allowed_secgroup (optional): ""
  #+ Security group ID to add to the allowed source_security_group_id of elasticsearch.
  allowed_secgroup = ""

  #. es_volume_size (optional): 15
  #+ The size of EBS volumes attached to data nodes (in GB)
  es_volume_size = 15

  #. es_zone_awareness_enabled (optional, bool): false
  # Indicates whether zone awareness is enabled [aws doc](https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-managedomains.html#es-managedomains-zoneawareness)
  es_zone_awareness_enabled = false

  #. es_version (optional): 7.1
  #+ The version of Elasticsearch to deploy.
  es_version = 7.1

  #. es_instance_type (optional): t2.small.elasticsearch
  #+ Instance type of data nodes in the cluster.
  es_instance_type = t2.small.elasticsearch

  #. es_instance_count (optional): 1
  #+ Number of instances in the cluster.
  es_instance_count = 1

  #. es_automated_snapshot_start_hour (optional): 23
  #+ Hour during which the service takes an automated daily snapshot of the indices in the domain.
  es_automated_snapshot_start_hour = 23

}
