output "ip_address" {
  value = google_compute_instance.main.network_interface.0.access_config.0.nat_ip
}
output "login" {
  value = "cycloid"
}
output "password" {
  value = random_string.password.result
}
output "instance_id" {
  value = google_compute_instance.main.instance_id
}
