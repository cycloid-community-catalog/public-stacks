# Cycloid variables
env = "trial"
project = "cycloid-worker"
customer = "bootstrap"

# Azure variables
azure_client_id = "YOUR_CLIENT_ID"
azure_client_secret = "YOUR_CLIENT_SECRET"
azure_subscription_id = "YOUR_SUB_ID"
azure_tenant_id = "YOUR_TENANT_ID"
azure_env = "public"
azure_location = "YOUR_LOCATION"
rg_name = "YOUR_EXISTING_RESOURCE_GROUP"

# Worker instance
vm_instance_type = "t3.small"
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
