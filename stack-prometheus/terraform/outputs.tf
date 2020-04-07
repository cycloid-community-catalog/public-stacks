#output "front_private_ips" {
#  value = "${module.prometheus.front_private_ips}"
#}

output "rds_address" {
  value       = module.prometheus.rds_address
  description = "Address of the RDS database."
}

output "rds_port" {
  value       = module.prometheus.rds_port
  description = "Port of the RDS database."
}

output "rds_username" {
  value       = module.prometheus.rds_username
  description = "Username of the RDS database."
}

output "rds_database" {
  value       = module.prometheus.rds_database
  description = "Database name of the RDS database."
}

output "rds_engine" {
  value       = module.prometheus.rds_engine
  description = "engine type of the RDS database."
}

output "prometheus_eip" {
  value       = module.prometheus.prometheus_eip
  description = "EIP of the Prometheus EC2 instance."
}

output "prometheus_secgroup_id" {
  value       = module.prometheus.prometheus_secgroup_id
  description = "Security group of the Prometheus EC2 instance."
}

