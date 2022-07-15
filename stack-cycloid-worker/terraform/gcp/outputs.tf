#
# VPC outputs
#
output "vpc_id" {
  description = "The ID for the VPC network"
  value       = module.cycloid-worker.vpc_id
}

output "vpc_name" {
  description = "The name for the VPC network"
  value       = module.cycloid-worker.vpc_name
}

output "subnet_id" {
  description = "The ID for the subnet"
  value       = module.cycloid-worker.subnet_id
}

output "subnet_name" {
  description = "The name for the subnet"
  value       = module.cycloid-worker.subnet_name
}


#
# Instance outputs
#
output "vm_ip" {
  description = "The IP address the worker"
  value       = module.cycloid-worker.vm_ip
}

output "vm_os_user" {
  description = "The username to use to connect to the instance via SSH."
  value       = module.cycloid-worker.vm_os_user
}