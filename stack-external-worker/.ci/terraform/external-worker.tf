# See the variables.tf file in module-infrastructure for a complete description
# of the options

module "external-worker" {
  #####################################
  # Do not modify the following lines #
  source = "./module-external-worker"

  project  = "${var.project}"
  env      = "${var.env}"
  customer = "${var.customer}"

  #####################################

  #. bastion_sg_allow (optional):
  #+ Amazon source security group ID which will be allowed to connect on Magento front port 22 (ssh)
  bastion_sg_allow = "env_bastion_sg_allow"
  #. keypair_name (requiredl): cycloid-external-worker
  #+ SSH keypair name to use to deploy ec2 instances
  keypair_name = "cycloid-external-worker"
  #. metrics_sg_allow (optional): ""
  #+ Additionnal security group ID to assign to Cycloid workers. Goal is to allow monitoring server to query metrics
  metrics_sg_allow = "env_metrics_sg_allow"
  #. public_subnets_ids (required, array):
  #+ Amazon public subnets IDs on which create each components.
  public_subnets_ids = ["env_public_subnets"]
  #. vpc_id (required):
  #+ Amazon VPC id on which create each components.
  vpc_id = "env_vpc_id"
  #. worker_count (required):
  #+ Number of Aws EC2 worker server to create.
  worker_count = 1
  #. worker_disk_size (optional): 20
  #+ Root disk size in Go of Aws EC2 worker servers.
  worker_disk_size = 20
  #. worker_volume_disk_size (optional): 130
  #+ Volume disk size in Go of Aws EC2 worker servers.
  worker_volume_disk_size = 130
  #. worker_ebs_optimized (optional, bool): true
  #+ Whether the Instance is EBS optimized or not, related to the instance type you choose.
  worker_ebs_optimized = true

  #. worker_launch_template_profile (optional): spot
  #+ Select launch template profile to use. Profile available "spot|ondemand"
  # Note : If you prefer to define your own launch_template
  # worker_launch_template_id = "${aws_launch_template.worker.id}"
  # worker_launch_template_latest_version = "${aws_launch_template.worker.latest_version}"

  #. worker_ami_id (optional, string): ""
  #+ If you don't want to use the builded ami but a specific ami (mainly used for debug).
  # worker_ami_id              = ""
  worker_ami_id = "amifoo"
  #. worker_type (optional): c5d.2xlarge
  #+ Type of AWS EC2 worker servers. This will be used for `spot` and `ondemand` launch config templates.
  worker_type = "c5d.2xlarge"

  #. worker_asg_min_size (optional): 1
  #+ Amazon Auto Scaling Group min size configuration.


  #. worker_asg_max_size (optional): 6
  #+ Amazon Auto Scaling Group max size configuration.

  #. worker_spot_price (optional): 0.3
  #+ The maximum hourly price you're willing to pay for the Spot Instances. Linked to instance type.
  worker_spot_price = "0.3"
}

#
# Auto Start / Stop
#
# Example to stop/start workers every night and weekend (UTC time)
#/!\ Be carefull when the worker is stopped, pipelines can't execute jobs


#resource "aws_autoscaling_schedule" "auto-stop" {
#  scheduled_action_name = "${var.customer}-${var.project}-${var.env} stop"
#  min_size = 0
#  max_size = -1
#  desired_capacity = 0
#  recurrence = "0 21 * * 1-5"
#  autoscaling_group_name = module.external-worker.asg_worker_name
#}


#resource "aws_autoscaling_schedule" "auto-start" {
#  scheduled_action_name = "${var.customer}-${var.project}-${var.env} start"
#  min_size = 1
#  max_size = -1
#  desired_capacity = 1
#  recurrence = "0 7 * * 1-5"
#  autoscaling_group_name = module.external-worker.asg_worker_name
#}

