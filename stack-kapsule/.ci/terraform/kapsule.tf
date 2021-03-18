#
# Create a Kapsule cluster + node pools
#

# Put here a custom name for the Kapsule Cluster
# Otherwise `${var.project}-${var.env}` will be used
locals {
  cluster_name = "ci-stack-kapsule"
}

module "kapsule" {
  #####################################
  # Do not modify the following lines #
  source = "./module-kapsule"

  project  = var.project
  env      = var.env
  customer = var.customer

  #####################################

  ###
  # General
  ###

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources. format { "foo" = "bar" }.

  ###
  # Control plane
  ###

  #. cluster_version (optional): 1.19
  #+ Kapsule cluster version.
  cluster_version = "1.19"

  #. cni (optional): cilium
  #+ The Container Network Interface (CNI) for the Kubernetes cluster (either `cilium`, `calico`, `weave` or `flannel`).

  #. ingress (optional): nginx
  #+ The ingress controller to be deployed on the Kubernetes cluster (either `nginx`, `traefik`, `traefik2` or `none`).

  #. enable_dashboard (optional): true
  #+ Enables the Kubernetes dashboard for the Kubernetes cluster.

  #. feature_gates (optional): []
  #+ The list of feature gates to enable on the cluster.

  #. admission_plugins (optional): []
  #+ The list of admission plugins to enable on the cluster.

  #. auto_upgrade (optional): true
  #+ Set to `true` to enable Kubernetes patch version auto upgrades. Important: When enabling auto upgrades, the `cluster_version` variable take a minor version like x.y (ie 1.18).

  ###
  # Required (should probably not be touched)
  ###

  cluster_name = local.kapsule_cluster_name
  scw_region   = var.scw_region
  scw_zone     = local.scw_zone
}

# You can duplicate this module to create mutiple Kapsule node pools.
# Make sure to change the module name and the `node_pool_name` field accordingly.
module "node_pool" {
  #####################################
  # Do not modify the following lines #
  source = "./module-node-pool"

  project  = var.project
  env      = var.env
  customer = var.customer

  #####################################

  ###
  # General
  ###

  #. extra_tags (optional): {}
  #+ Dict of extra tags to add on aws resources. format { "foo" = "bar" }.

  ###
  # Nodes
  ###

  #. node_pool_name (optional): standard
  #+ Node group given name.
  node_pool_name = "standard"

  #. node_type (optional): GP1-XS
  #+ Type of instance to use for node servers.
  node_type = "DEV1-S"

  #. node_count (optional): 1
  #+ Desired number of node servers.
  node_count = "1"

  #. enable_autoscaling (optional): false
  #+ Enables the autoscaling feature for this pool. Important: When enabled, an update of the size will not be taken into account.

  #. node_autoscaling_min_size (optional): 1
  #+ The minimum size of the pool, used by the autoscaling feature.

  #. node_autoscaling_max_size (optional): 10
  #+ The maximum size of the pool, used by the autoscaling feature.

  #. enable_autohealing (optional): true
  #+ Enables the autohealing feature for this pool.

  #. container_runtime (optional): docker
  #+ The container runtime of the pool. Important: Updates to this field will recreate a new resource.

  #. placement_group_id (optional): ""
  #+ The placement group the nodes of the pool will be attached to. Important: Updates to this field will recreate a new resource.

  #. wait_for_pool_ready (optional): true
  #+ Whether to wait for the pool to be ready.

  ###
  # Required (should probably not be touched)
  ###

  cluster_id   = module.kapsule.cluster_id
  cluster_name = module.kapsule.cluster_name
  scw_region   = var.scw_region
  scw_zone     = local.scw_zone
}
