resource "random_string" "password" {
  length           = 16
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "_%@"
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh.tpl")

  vars = {
    password = random_string.password.result
  }
}

resource "google_compute_firewall" "default" {
  name    = local.name_prefix
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = [local.name_prefix]
}

resource "google_compute_instance" "main" {
  name         = local.name_prefix
  machine_type = var.instance_type
  zone         = var.gcp_zone

  tags = [local.name_prefix]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  labels = {
    cycloidio    = "true"
    env          = var.env
    project      = var.project
    organization = var.organization
    component    = var.component
  }


  metadata_startup_script = data.template_file.user_data.rendered
}
