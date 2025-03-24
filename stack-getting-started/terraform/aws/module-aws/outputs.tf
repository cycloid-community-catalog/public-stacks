output "login" {
  value = "cycloid"
}
output "password" {
  value = random_string.password.result
}
output "ip_address" {
  value = aws_instance.front.public_ip
}

output "id" {
  value = aws_instance.front.id
}
