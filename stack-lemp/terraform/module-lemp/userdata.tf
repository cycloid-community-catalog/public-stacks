# Workaround to have elasticache_address optional

data "template_file" "user_data_front" {
  template = file("${path.module}/templates/userdata.sh.tpl")

  vars = {
    env                = var.env
    project            = var.project
    customer           = var.customer
    role               = "front"
    signal_stack_name  = "${var.project}-front-${var.env}"
    signal_resource_id = "Fronts${var.env}"
    rds_address        = join("", aws_db_instance.application.*.address)
    rds_port           = join("", aws_db_instance.application.*.port)
    rds_database       = join("", aws_db_instance.application.*.name)
    rds_username       = join("", aws_db_instance.application.*.username)
    s3_medias          = join("", aws_s3_bucket.medias.*.id)
    elasticache_address = element(
      concat(
        [
          replace(
            replace(
              jsonencode(aws_elasticache_cluster.redis.*.cache_nodes),
              "/.*address...([a-z0-9\\.\\-]+)\".*/",
              "$1",
            ),
            "[]",
            "",
          ),
        ],
        [""],
      ),
      0,
    )
  }
}
