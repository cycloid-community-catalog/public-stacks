output "asg_workers_sec_group_id" {
  description = "Security group ID of workers."
  value       = module.external-worker.asg_workers_sec_group_id
}
