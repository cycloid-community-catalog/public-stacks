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
  # Instance
  #

  #. vm_machine_type: 'n2-standard-2'
  #+ Machine type for the instance
  vm_machine_type = var.vm_machine_type

  #. vm_disk_size: 20
  #+ Disk size for the Cycloid worker (Go)
  vm_disk_size = var.vm_disk_size

  #. vm_os_user: admin
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