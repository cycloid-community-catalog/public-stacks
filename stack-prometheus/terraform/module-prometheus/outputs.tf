#ELB

#output "elb_prometheus_dns_name" {
#  value = "${aws_elb.prometheus.dns_name}"
#}
#
#output "elb_prometheus_zone_id" {
#  value = "${aws_elb.prometheus.zone_id}"
#}
#
#output "prometheus_private_ips" {
#    value = "${join(",", aws_instance.prometheus.*.private_ip)}"
#}

output "prometheus_eip" {
  value = var.prometheus_enable_eip ? aws_eip.prometheus[0].public_ip : ""
}

output "prometheus_secgroup_id" {
  value = aws_security_group.prometheus.id
}

output "prometheus_instance_id" {
  value = aws_instance.prometheus.id
}

output "rds_address" {
  value = var.create_rds_database ? aws_db_instance.grafana[0].address : ""
}

output "rds_port" {
  value = var.create_rds_database ? aws_db_instance.grafana[0].port : ""
}

output "rds_database" {
  value = var.create_rds_database ? aws_db_instance.grafana[0].name : ""
}

output "rds_username" {
  value = var.create_rds_database ? aws_db_instance.grafana[0].username : ""
}

output "rds_engine" {
  value = var.create_rds_database ? aws_db_instance.grafana[0].engine : ""
}
