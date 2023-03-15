# Cycloid variables
env = "trial"
project = "cycloid-worker"
customer = "bootstrap"

# AWS variables
aws_cred = {
    access_key = "<YOUR_ACCESS_KEY>",
    secret_key = "<YOUR_SECRET_KEY>",
}
aws_region = "<YOUR_REGION>"

# Worker instance
vm_instance_type = "t3.small"
vm_disk_size = "30"
keypair_public = "<YOUR_PUBLIC_KEY>"

# Worker config
worker_key = <<-EOF
-----BEGIN RSA PRIVATE KEY-----
xxx
-----END RSA PRIVATE KEY-----
EOF
team_id = "YOUR_TEAM_ID"
