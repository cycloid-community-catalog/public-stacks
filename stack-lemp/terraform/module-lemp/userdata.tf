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
    rds_address        = try(aws_db_instance.application[0].address, "")
    rds_port           = try(aws_db_instance.application[0].port, "")
    rds_database       = try(aws_db_instance.application[0].db_name, "")
    rds_username       = try(aws_db_instance.application[0].username, "")
    s3_medias          = try(aws_s3_bucket.medias[0].id, "")
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
