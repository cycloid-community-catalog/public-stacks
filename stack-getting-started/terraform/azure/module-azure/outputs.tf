output "ip_address" {
  value = azurerm_public_ip.main.ip_address
}
output "login" {
  value = "cycloid"
}
output "password" {
  value = random_string.password.result
}
