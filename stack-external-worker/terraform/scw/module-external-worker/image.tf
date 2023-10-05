data "scaleway_instance_image" "worker" {
  count = var.worker_image_id == "" ? 1 : 0
  
  name         = "${var.project}_worker_${var.env}"
  architecture = "x86_64"
  latest       = true
}

locals {
  image_id = var.worker_image_id != "" ? var.worker_image_id : element(data.scaleway_instance_image.worker.*.id, 0)
}
