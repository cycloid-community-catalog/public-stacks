output "login" {
  value       = module.instance.login
  description = "User to login on the server"
}
output "password" {
  value       = module.instance.password
  description = "Password to login on the server"
}
output "ip_address" {
  value       = module.instance.ip_address
  description = "IP of the server"
}
