data "template_file" "user_data_concourse" {
  template = "${file("${path.module}/templates/userdata.sh.tpl")}"

  vars {
    env                = "${var.env}"
    project            = "${var.project}"
    role               = "concourse-server"
    signal_stack_name  = "${var.project}-concourse-${var.env}"
    signal_resource_id = "concourseServer${var.env}"
    rds_address        = "${aws_db_instance.concourse.address}"
    rds_port           = "${aws_db_instance.concourse.port}"
    rds_database       = "${aws_db_instance.concourse.name}"
    rds_username       = "${aws_db_instance.concourse.username}"
  }
}
