output "elasticsearch_domain_endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}

output "elasticsearch_domain_kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}

