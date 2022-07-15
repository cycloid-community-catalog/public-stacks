# Cycloid variables
env = "trial"
project = "cycloid-worker"
customer = "bootstrap"

# AWS variables
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"
aws_region = "YOUR_REGION"

# Worker instance
vm_instance_type = "t3.small"
vm_disk_size = "20"
keypair_public = "YOUR_PUBLIC_KEY"

# Worker config
team_id = "YOUR_TEAM_ID"
worker_key = <<-EOF
-----BEGIN RSA PRIVATE KEY-----
xxx
-----END RSA PRIVATE KEY-----
EOF
