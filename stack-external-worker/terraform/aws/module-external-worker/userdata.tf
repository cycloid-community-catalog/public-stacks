data "template_file" "user_data_worker" {
  template = file("${path.module}/templates/userdata.sh.tpl")

  vars = {
    customer           = var.customer
    project            = var.project
    env                = var.env
    role               = "worker"
    signal_stack_name  = "${var.project}-worker-${var.env}"
    signal_resource_id = "externalWorkers${var.env}"
  }
}
