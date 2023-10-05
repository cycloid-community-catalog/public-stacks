output node_pool_id {
  description = "Kapsule node pool ID."
  value       = scaleway_k8s_pool_beta.nodes.id
}

output node_pool_status {
  description = "Kapsule node pool status."
  value       = scaleway_k8s_pool_beta.nodes.status
}

output node_pool_version {
  description = "Kapsule node pool version."
  value       = scaleway_k8s_pool_beta.nodes.version
}

output node_pool_current_size {
  description = "Kapsule node pool current size."
  value       = scaleway_k8s_pool_beta.nodes.current_size
}

output node_pool_nodes {
  description = "Kapsule node pool nodes informations."
  value       = scaleway_k8s_pool_beta.nodes.nodes
}

output node_pool_public_ips {
  description = "Kapsule node pool public IPs."
  value       = scaleway_k8s_pool_beta.nodes.nodes.*.public_ip
}

output node_pool_public_ipv6s {
  description = "Kapsule node pool public IPv6s."
  value       = scaleway_k8s_pool_beta.nodes.nodes.*.public_ip_v6
}