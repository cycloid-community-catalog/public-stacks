output "asg_concourse_sec_group_id" {
  value       = "${module.concourse-server.asg_concourse_sec_group_id}"
  description = "Security group ID of Concourse servers"
}

output "alb_dns_name" {
  value       = "${module.concourse-server.alb_dns_name}"
  description = "DNS name of the ALB on top of Concourse servers"
}

output "alb_zone_id" {
  value       = "${module.concourse-server.alb_zone_id}"
  description = "Zone ID of the ALB on top of Concourse servers"
}

output "nlb_dns_name" {
  value       = "${module.concourse-server.nlb_dns_name}"
  description = "DNS name of the NLB on top of Concourse servers"
}

output "nlb_zone_id" {
  value       = "${module.concourse-server.nlb_zone_id}"
  description = "Zone ID of the NLB on top of Concourse servers"
}

output "rds_address" {
  value       = "${module.concourse-server.rds_address}"
  description = "Address of the RDS database."
}

output "rds_port" {
  value       = "${module.concourse-server.rds_port}"
  description = "Port of the RDS database."
}

output "rds_username" {
  value       = "${module.concourse-server.rds_username}"
  description = "Username of the RDS database."
}

output "rds_database" {
  value       = "${module.concourse-server.rds_database}"
  description = "Database name of the RDS database."
}
