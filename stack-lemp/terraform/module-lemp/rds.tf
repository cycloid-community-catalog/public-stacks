###

# RDS

###

resource "aws_security_group" "rds" {
  count       = var.create_rds ? 1 : 0
  name        = "${var.project}-rds-${var.env}"
  description = "rds ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [aws_security_group.front.id]
  }

  tags = merge(var.extra_tags, {
    Name = "${var.project}-rds-${var.env}"
    role = "rds"
  })
}

resource "aws_db_instance" "application" {
  count             = var.create_rds ? 1 : 0
  depends_on        = [aws_security_group.rds]
  identifier        = replace("${var.project}-rds-${var.env}", var.nameregex, "")
  allocated_storage = var.rds_disk_size
  storage_type      = var.rds_storage_type
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_type
  name              = var.rds_database
  username          = var.rds_username
  password          = var.rds_password

  multi_az                  = var.rds_multiaz
  apply_immediately         = true
  maintenance_window        = "tue:06:00-tue:07:00"
  backup_window             = "02:00-04:00"
  backup_retention_period   = var.rds_backup_retention
  copy_tags_to_snapshot     = true
  final_snapshot_identifier = replace("${var.customer}-${var.project}-rds-${var.env}", var.nameregex, "")
  skip_final_snapshot       = var.rds_skip_final_snapshot

  parameter_group_name = var.rds_parameters
  db_subnet_group_name = var.rds_subnet_group != "" ? var.rds_subnet_group : aws_db_subnet_group.rds-subnet[0].id

  vpc_security_group_ids = compact([var.rds_extra_sg_allow, aws_security_group.rds[0].id])

  tags = merge(var.extra_tags, {
    Name = "${var.customer}-${var.project}-rds-${var.env}"
    type = "master"
    role = "rds"
  })
}

resource "aws_db_subnet_group" "rds-subnet" {
  name        = "rds-${var.project}-${var.vpc_id}-${var.env}"
  count       = var.rds_subnet_group == "" && var.create_rds ? 1 : 0
  description = "subnet-rds-${var.project}-${var.env}-${var.vpc_id}"
  subnet_ids  = var.private_subnets_ids
}

#
# Output
#

output "rds_address" {
  value = join("", aws_db_instance.application.*.address)
}

output "rds_port" {
  value = join("", aws_db_instance.application.*.port)
}

output "rds_database" {
  value = join("", aws_db_instance.application.*.name)
}

output "rds_username" {
  value = join("", aws_db_instance.application.*.username)
}
