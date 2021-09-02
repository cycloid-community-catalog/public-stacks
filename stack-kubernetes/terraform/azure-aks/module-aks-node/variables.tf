#
# General
#

variable "project" {
  description = "Cycloid project name."
}

variable "env" {
  description = "Cycloid environment name."
}

variable "customer" {
  description = "Cycloid customer name."
}

#
# Networking
#

variable "network_subnet_id" {
  description = "Network subnet ID that should be used by AKS nodes."
}

variable "enable_node_public_ip" {
  description = "Should be true if public IPs should be associated to AKS nodes."
  default     = false
}

#
# Control plane
#

variable "cluster_name" {
  description = "AKS Cluster given name."
}

variable "cluster_id" {
  description = "AKS Cluster ID."
}

#
# Nodes
#

variable "node_pool_name" {
  description = "AKS node pool given name."
  default     = "standard"
}

variable "node_availability_zones" {
  description = "To use specific Azure Availability Zones for the nodes pool. @see https://docs.microsoft.com/en-us/azure/availability-zones/az-overview"
  default     = []
}

variable "node_size" {
  description = "AKS nodes virtualmachine size."
  default     = "Standard_DS2_v2"
}

variable "node_count" {
  description = "AKS nodes desired count."
  default     = 1
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling of AKS nodes."
  default     = true
}

variable "node_min_count" {
  description = "AKS nodes auto scaling minimum count."
  default     = 1
}

variable "node_max_count" {
  description = "AKS nodes auto scaling group maximum count."
  default     = 10
}

variable "node_disk_size" {
  description = "AKS nodes root disk size."
  default     = "60"
}

variable "node_os_type" {
  description = "AKS nodes OS type, can be either `Linux` or `Windows`. Windows pool nodes needs to be enabled via the Azure CLI. @see https://github.com/Azure/AKS/blob/master/previews.md#windows-worker-nodes-"
  default     = "Linux"
}

variable "node_max_pods" {
  description = "Maximum number of pods per AKS node (can't be more than 250)."
  default     = "250"
}

variable "node_taints" {
  description = "AKS nodes taints to setup."
  default     = []
}