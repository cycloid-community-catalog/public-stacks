###

# ELK

###

resource "aws_elasticsearch_domain" "es" {
  domain_name = "${var.project}-${var.env}"

  # EBS storage must be selected for t2.small.elasticsearch
  ebs_options {
    ebs_enabled = true
    volume_size = var.es_volume_size
  }

  elasticsearch_version = var.es_version

  cluster_config {
    instance_count         = var.es_instance_count
    instance_type          = var.es_instance_type
    zone_awareness_enabled = var.es_zone_awareness_enabled
  }

  snapshot_options {
    automated_snapshot_start_hour = var.es_automated_snapshot_start_hour
  }

  vpc_options {
    security_group_ids = [aws_security_group.es.id]
    subnet_ids         = slice(var.subnet_ids, 0, var.es_instance_count)
  }

  tags = merge(local.merged_tags, {
    role = "es"
    Name = "${var.project}-es-${var.env}"
  })
}

resource "aws_elasticsearch_domain_policy" "es" {
  domain_name = aws_elasticsearch_domain.es.domain_name

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Action": [
        "es:*"
      ],
      "Resource": "${aws_elasticsearch_domain.es.arn}/*"
    }
  ]
}
POLICIES

}
