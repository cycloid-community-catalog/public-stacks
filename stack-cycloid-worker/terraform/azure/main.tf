module "cycloid-worker" {
  #####################################
  # Do not modify the following lines #
  source   = "./module-cycloid-worker"

  project  = var.project
  env      = var.env
  customer = var.customer
  #####################################

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on resources. format { "foo" = "bar" }.
  extra_tags = {
    demo = true
    monitoring_discovery = false
  }

  #
  # Cloud provider
  #

  #. azure_location: "West Europe"
  #+ Azure location
  azure_location = var.azure_location

  #. rg_name: "cycloid-worker"
  #+ Resource Group name
  rg_name = var.rg_name

  #
  # Instance
  #

  #. vm_instance_type: 'Standard_DS2_v2'
  #+ Instance type for the Cycloid worker
  vm_instance_type = var.vm_instance_type

  #. vm_disk_size: 20
  #+ Disk size for the Cycloid worker (Go)
  vm_disk_size = var.vm_disk_size

  #. vm_os_user: cycloid
  #+ Admin username for newly created instances
  vm_os_user = var.vm_os_user

  #. keypair_public: ""
  #+ The public SSH key, for SSH access to newly-created instances
  keypair_public = var.keypair_public


  #
  # Cycloid worker
  #

  #. team_id: ""
  #+ This parameter can be obtained in Cycloid console, by clicking on your profile picture at the top right corner, then organization settings, then use the value of the ci_team_member field.
  team_id = var.team_id

  #. worker_key: ""
  #+ This parameter can be obtained in Cycloid console, by clicking on security/credentials section on the left menu, then look for of a credential named Cycloid-worker-keys, then use the value of the ssh_prv field.
  worker_key = var.worker_key
}