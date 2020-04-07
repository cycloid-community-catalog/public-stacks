###

# RDS (mysql DB for grafana)

###

resource "aws_security_group" "rds" {
  count       = var.create_rds_database ? 1 : 0
  name        = "${var.project}-rds-${var.env}"
  description = "rds ${var.env} for ${var.project}"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [aws_security_group.prometheus.id]
  }

  tags = merge(local.merged_tags, {
    Name         = "${var.project}-rds-${var.env}"
    role         = "rds"
  })
}

resource "aws_db_instance" "grafana" {
  count             = var.create_rds_database ? 1 : 0
  depends_on        = [aws_security_group.rds]
  identifier        = "${var.project}-rds-${var.env}"
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
  final_snapshot_identifier = "${var.project}-rds-${var.short_region[var.aws_region]}-${var.env}"
  skip_final_snapshot       = var.rds_skip_final_snapshot

  parameter_group_name   = var.rds_parameters
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet[0].id
  vpc_security_group_ids = [aws_security_group.rds[0].id]

  tags = merge(local.merged_tags, {
    Name         = "${var.project}-rds-${var.short_region[var.aws_region]}-${var.env}"
    role         = "rds"
    type         = "master"
  })
}

resource "aws_db_subnet_group" "rds-subnet" {
  count       = var.create_rds_database ? 1 : 0
  name        = "engine-cycloid.io_subnet-rds-${var.vpc_id}"
  description = "subnet-rds-${var.vpc_id}"
  subnet_ids  = var.private_subnets_ids
}

