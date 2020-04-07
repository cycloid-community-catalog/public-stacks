#alb

output "alb_front_dns_name" {
  value = aws_alb.front.dns_name
}

output "alb_front_zone_id" {
  value = aws_alb.front.zone_id
}

