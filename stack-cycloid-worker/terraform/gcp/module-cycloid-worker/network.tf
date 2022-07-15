resource "google_compute_network" "cycloid-worker" {
  name = "${var.customer}-${var.project}-${var.env}-cycloid-worker"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cycloid-worker" {
  name          = "${var.customer}-${var.project}-${var.env}-cycloid-worker-subnet"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.cycloid-worker.id
}