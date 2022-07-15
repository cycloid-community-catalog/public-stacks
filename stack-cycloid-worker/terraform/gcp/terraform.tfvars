# Cycloid variables
env = "trial"
project = "cycloid-worker"
customer = "bootstrap"

# GCP variables
gcp_project = "YOUR_PROJECT"
gcp_region = "YOUR_REGION"

# Worker instance
vm_machine_type = "n2-standard-2"
vm_disk_size = "20"
vm_os_user = "cycloid"
keypair_public = "YOUR_PUBLIC_KEY"

# Worker config
team_id = "YOUR_TEAM_ID"
worker_key = <<-EOF
-----BEGIN RSA PRIVATE KEY-----
xxx
-----END RSA PRIVATE KEY-----
EOF
