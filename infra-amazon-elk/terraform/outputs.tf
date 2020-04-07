output "elasticsearch_domain_endpoint" {
  value       = module.elk.elasticsearch_domain_endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
}

output "elasticsearch_domain_kibana_endpoint" {
  value       = module.elk.elasticsearch_domain_kibana_endpoint
  description = "Domain-specific endpoint for kibana without https scheme."
}
