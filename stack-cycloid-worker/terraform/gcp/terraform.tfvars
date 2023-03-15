# Cycloid variables
env = "trial"
project = "cycloid-worker"
customer = "bootstrap"

# GCP variables
gcp_project = "<YOUR_PROJECT>"
# GCP region such as "europe-west1"
gcp_region = "<YOUR_REGION>"
# GCP zone to append to the region such as "b"
gcp_zone = "<YOUR_ZONE>"

# Worker instance
vm_machine_type = "n2-standard-2"
vm_disk_size = "30"
keypair_public = "<YOUR_PUBLIC_KEY>"

# Worker config
worker_key = <<-EOF
-----BEGIN RSA PRIVATE KEY-----
xxx
-----END RSA PRIVATE KEY-----
EOF
team_id = "YOUR_TEAM_ID"
