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

variable "resource_group_name" {
  description = "Azure Resource Group to use."
}

variable "location" {
  description = "Specific Azure Location to use."
}

variable "extra_tags" {
  description = "Extra tags to add to all resources."
  default     = {}
}

locals {
  standard_tags = {
    "cycloid.io" = "true"
    env          = var.env
    project      = var.project
    client       = var.customer
  }
  merged_tags = merge(local.standard_tags, var.extra_tags)
}

#
# Networking
#

# variable "vnet_subnet_id" {
#   description = "Network subnet ID that should for the default node pool."
# }

variable "network_plugin" {
  description = "AKS cluster network plugin to use, can be either `azure` or `kubenet`."
  default     = "azure"
}

variable "network_policy_plugin" {
  description = "AKS cluster network policy plugin to use, can be either `azure` or `calico`. `azure` only available with `network_plugin = azure`."
  default     = "azure"
}

variable "network_pod_cidr" {
  description = "AKS cluster pod CIDR to use, required if `network_plugin = kubenet`."
  default     = "10.9.0.0/16"
}

variable "network_service_cidr" {
  description = "AKS cluster service CIDR to use, required if `network_plugin = azure`."
  default     = "10.10.0.0/16"
}

variable "network_docker_bridge_cidr" {
  description = "AKS cluster service CIDR to use, required if `network_plugin = azure`."
  default     = "172.17.0.1/16"
}

variable "network_load_balancer_sku" {
  description = "AKS cluster load balancer SKU, can be either `basic` or `standard`."
  default     = "basic"
}

#
# Control plane
#

variable "cluster_name" {
  description = "AKS Cluster given name."
}

variable "cluster_version" {
  description = "AKS Cluster version to use, defaults to the latest recommended but no auto-upgrade."
  type        = string
  default     = null
}

variable "cluster_allowed_ips" {
  description = "Allow Inbound IP CIDRs to access the Kubernetes API."
  default     = []
}

variable "service_principal_client_id" {
  description = "The Client ID for the Service Principal used by the cluster."
  type        = string
}

variable "service_principal_client_secret" {
  description = "The Client Secret for the Service Principal used by the cluster."
  type        = string
}

variable "node_admin_username" {
  description = "AKS node admin username for SSH connection."
  default     = "cycloid"
}

variable "node_ssh_key" {
  description = "AKS node admin SSH key for SSH connection."
  default     = ""
}

variable "enable_pod_security_policy" {
  description = "Should be `true` to enable Pod Security Policies. Pod Security Policies needs to be enabled via the Azure CLI. @see https://github.com/Azure/AKS/blob/master/previews.md#kubernetes-pod-security-policies-"
  default     = false
}

variable "enable_rbac" {
  description = "Should be `true` to enable Role Based Access Control."
  default     = true
}

variable "rbac_use_active_directory" {
  description = "Should be `true` to enable Role Based Access Control with an Azure Active Directory."
  default     = false
}

variable "rbac_client_app_id" {
  description = "The Client ID of an Azure Active Directory Application for Role Based Access Control."
  default     = ""
}

variable "rbac_server_app_id" {
  description = "The Server ID of an Azure Active Directory Application for Role Based Access Control."
  default     = ""
}

variable "rbac_client_app_secret" {
  description = "The Server Secret of an Azure Active Directory Application for Role Based Access Control."
  default     = ""
}

variable "enable_oms_agent" {
  description = "Should be `true` to enable OMS agent for log analytics."
  default     = true
}

variable "log_analytics_workspace_sku" {
  description = "The Log Analytics workspace SKU to use if `enable_oms_agent = true`."
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The Log Analytics retention in days to use if `enable_oms_agent = true`."
  default     = "30"
}

variable "enable_kube_dashboard" {
  description = "Should be `true` to enable the Kubernetes Dashboard."
  default     = false
}

#
# Default Node Pool
#
variable "node_pool_name" {
  description = "AKS default nodes pool given name."
  default     = "default"
}

variable "node_pool_type" {
  description = "AKS nodes pool type, can be either `AvailabilitySet` or `VirtualMachineScaleSets`."
  default     = "VirtualMachineScaleSets"
}

variable "node_availability_zones" {
  description = "To use specific Azure Availability Zones for the default nodes pool. @see https://docs.microsoft.com/en-us/azure/availability-zones/az-overview"
  default     = []
}

variable "node_network_subnet_id" {
  description = "Network subnet ID that should be used by AKS default nodes."
}

variable "node_enable_public_ip" {
  description = "Should be true if public IPs should be associated to AKS default nodes."
  default     = false
}

variable "node_size" {
  description = "AKS default nodes virtualmachine size."
  default     = "Standard_DS2_v2"
}

variable "node_count" {
  description = "AKS default nodes desired count."
  default     = 1
}

variable "node_enable_auto_scaling" {
  description = "Enable auto scaling of AKS default nodes."
  default     = true
}

variable "node_min_count" {
  description = "AKS default nodes auto scaling minimum count."
  default     = 1
}

variable "node_max_count" {
  description = "AKS default nodes auto scaling group maximum count."
  default     = 10
}

variable "node_disk_size" {
  description = "AKS default nodes root disk size."
  default     = "60"
}

variable "node_max_pods" {
  description = "Maximum number of pods per AKS default node (can't be more than 250)."
  default     = "250"
}

variable "node_taints" {
  description = "AKS default nodes taints to setup."
  default     = []
}