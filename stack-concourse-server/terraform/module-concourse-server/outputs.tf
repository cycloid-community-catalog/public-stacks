output "role_concourse" {
  value = "${aws_iam_role.concourse.arn}"
}

# ASG
output "asg_concourse_name" {
  value = "${aws_cloudformation_stack.concourse.outputs["AsgName"]}"
}

output "asg_concourse_sec_group_id" {
  value = "${aws_security_group.concourse.id}"
}

# ALB
output "alb_sec_group_id" {
  value = "${var.concourse_create_alb ? join("", aws_security_group.alb-concourse.*.id) : ""}"
}

output "alb_id" {
  value = "${var.concourse_create_alb ? join("", aws_alb.concourse.*.id) : ""}"
}

output "alb_dns_name" {
  value = "${var.concourse_create_alb ? join("", aws_alb.concourse.*.dns_name) : ""}"
}

output "alb_zone_id" {
  value = "${var.concourse_create_alb ? join("", aws_alb.concourse.*.zone_id) : ""}"
}

# NLB
output "nlb_id" {
  value = "${aws_lb.concourse.id}"
}

output "nlb_dns_name" {
  value = "${aws_lb.concourse.dns_name}"
}

output "nlb_zone_id" {
  value = "${aws_lb.concourse.zone_id}"
}

# RDS
output "rds_address" {
  value = "${aws_db_instance.concourse.address}"
}

output "rds_port" {
  value = "${aws_db_instance.concourse.port}"
}

output "rds_database" {
  value = "${aws_db_instance.concourse.name}"
}

output "rds_username" {
  value = "${aws_db_instance.concourse.username}"
}
