output "role_worker" {
  value = aws_iam_role.worker.arn
}

# ASG
output "asg_worker_name" {
  value = aws_cloudformation_stack.worker.outputs["AsgName"]
}

output "asg_workers_sec_group_id" {
  value = aws_security_group.worker.id
}
