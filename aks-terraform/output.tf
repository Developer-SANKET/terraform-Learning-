# ============================================================
# outputs.tf — values printed after `terraform apply
# ============================================================
output "resource_group_name" {
  description = "Resource group containing all resources"
  value       = azurerm_resource_group.aks.name
}

output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kube_config_command" {
  description = "Run this command to configure kubectl on your machine"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name}"
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.aks.id
}

output "node_subnet_id" {
  description = "Subnet ID where both B2ms nodes live"
  value       = azurerm_subnet.aks_nodes.id
}

output "node_resource_group" {
  description = "Auto-created RG where Azure puts node VMs, disks, NICs"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "kubernetes_version" {
  description = "Kubernetes version running on the cluster"
  value       = azurerm_kubernetes_cluster.aks.kubernetes_version
}

output "cluster_fqdn" {
  description = "Public FQDN of the managed API server"
  value       = azurerm_kubernetes_cluster.aks.fqdn
}
