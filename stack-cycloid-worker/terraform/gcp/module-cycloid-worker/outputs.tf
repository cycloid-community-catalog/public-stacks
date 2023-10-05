#
# VPC outputs
#
output "vpc_id" {
  description = "The VPC ID for the VPC"
  value       = google_compute_network.cycloid-worker.id
}

output "vpc_name" {
  description = "The name for the VPC"
  value       = google_compute_network.cycloid-worker.name
}

output "subnet_id" {
  description = "The ID for the subnet"
  value       = google_compute_subnetwork.cycloid-worker.id
}

output "subnet_name" {
  description = "The name for the subnet"
  value       = google_compute_subnetwork.cycloid-worker.name
}

#
# Instance outputs
#
output "vm_ip" {
  description = "The IP address the worker"
  value       = google_compute_instance.cycloid-worker.network_interface.0.access_config.0.nat_ip
}

output "vm_os_user" {
  description = "The username to use to connect to the instance via SSH."
  value       = var.vm_os_user
}