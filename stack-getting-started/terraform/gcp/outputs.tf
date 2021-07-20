output "login" {
  value       = module.instance.login
  description = "User to login on the server"
}
output "password" {
  value       = module.instance.password
  description = "Password to login on the server"
}
output "instance_id" {
  value       = module.instance.instance_id
  description = "The ID of the cloud instance created"
}
output "ip_address" {
  value       = module.instance.ip_address
  description = "IP of the server"
}
output "connection_command" {
  value       = "gcloud compute ssh --project=${var.gcp_project} --zone=${var.gcp_zone} ${module.instance.instance_id}"
  description = "How to connect on the server https://cloud.google.com/compute/docs/instances/connecting-to-instance"
}
