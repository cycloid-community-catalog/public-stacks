module "avd" {
  #####################################
  # Do not modify the following lines #
  source   = "./module-avd"
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

  #. app_group_type: 'Desktop'
  #+ The type of Virtual Desktop Application Group. Valid options are RemoteApp or Desktop application groups
  app_group_type = "Value injected by StackForms"

  #. host_pool_type: 'Personal'
  #+ The type of the Virtual Desktop Host Pool. Valid options are Personal or Pooled. Changing the type forces a new resource to be created
  host_pool_type = "Value injected by StackForms"

  #. host_pool_expiration_date: ''
  #+ A valid RFC3339Time for the expiration of the token (between 1 hour and 30 days from now). For example: 2022-01-01T23:40:52Z
  host_pool_expiration_date = "Value injected by StackForms"

  #. host_pool_lb_type: 'DepthFirst'
  #+ TBreadthFirst load balancing distributes new user sessions across all available session hosts in the host pool. DepthFirst load balancing distributes new user sessions to an available session host with the highest number of connections but has not reached its maximum session limit threshold
  host_pool_lb_type = "Value injected by StackForms"

  #. host_pool_max_sessions: 16
  #+ Maximum number of users that have concurrent sessions on a session host. Should only be set if the type of your Virtual Desktop Host Pool is Pooled
  host_pool_max_sessions = "Value injected by StackForms"

  #. rg_name: 'cycloid-get-started'
  #+ The name of the existing resource group where the resources will be deployed
  rg_name = "Value injected by StackForms"
}
