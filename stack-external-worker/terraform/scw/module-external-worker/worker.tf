
resource "scaleway_instance_security_group" "worker" {
  name = "${var.project}-worker-${var.env}"

  inbound_default_policy = "drop"
  outbound_default_policy = "accept"

  dynamic "inbound_rule" {
    for_each = var.ssh_allowed_ips

    content {
      action   = "accept"
      protocol = "TCP"
      port     = 22
      ip       = inbound_rule.value
    }
  }

  dynamic "inbound_rule" {
    for_each = var.metrics_allowed_ips

    content {
      action   = "accept"
      protocol = "TCP"
      port     = 9100
      ip       = inbound_rule.value
    }
  }  
}

resource "scaleway_instance_ip" "public" {
  count = var.worker_count
}

resource "scaleway_instance_volume" "data" {
  count = var.worker_volume_disk_size != 0 ? var.worker_count : 0

  name       = "${var.project}-worker-${var.env}-${count.index}"
  size_in_gb = var.worker_volume_disk_size
  type       = var.worker_volume_disk_type
}

resource "scaleway_instance_server" "worker" {
  count = var.worker_count

  name  = "${var.project}-worker-${var.env}-${count.index}"
  type  = var.worker_type
  image = local.image_id 
  ip_id = scaleway_instance_ip.public[count.index].id

  tags = compact(concat(local.merged_tags, [
    "name=${var.project}-worker-${var.env}-${count.index}",
    "role=worker"
  ]))

  root_volume {
    size_in_gb            = var.worker_volume_disk_type == "l_ssd" ? var.scw_instance_disk_size[var.worker_type] - var.worker_volume_disk_size : var.scw_instance_disk_size[var.worker_type]
    delete_on_termination = true
  }

  additional_volume_ids = var.worker_volume_disk_size != 0 ? [ scaleway_instance_volume.data[count.index].id ] : []
  security_group_id     = scaleway_instance_security_group.worker.id

  user_data {
    key   = "customer"
    value = var.customer
  }

  user_data {
    key   = "project"
    value = var.project
  }

  user_data {
    key   = "env"
    value = var.env
  }

  user_data {
    key   = "role"
    value = "worker"
  }

  cloud_init = templatefile("${path.module}/templates/cloud-init.sh.tpl", {
    customer = var.customer,
    project  = var.project,
    env      = var.env,
    role     = "worker"
  })
}
