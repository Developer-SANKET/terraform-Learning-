# ============================================================
# main.tf — AKS cluster with two B2ms nodes on a custom VNet
# ============================================================


terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

# ─────────────────────────────────────────
#  Resource Group
# ─────────────────────────────────────────
resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# ─────────────────────────────────────────
#   Virtual Network  (the "VNet" box)
# ─────────────────────────────────────────
resource "azurerm_virtual_network" "aks" {
  name                = "vnet-${var.cluster_name}"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = [var.vnet_cidr]   # default: "10.0.0.0/16"

  tags = var.tags
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "snet-aks-nodes"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = [var.subnet_cidr]  # default: "10.0.1.0/24"
}

# ─────────────────────────────────────────
#   AKS Cluster
# ─────────────────────────────────────────
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  # Kubernetes DNS prefix (appears in the API server FQDN)
  dns_prefix = var.cluster_name

  # ── Node Pool ──────────────────────────────────────────────
  # This is your "system" node pool — AKS requires at least one.
  # Standard_B2ms = 2 vCPU, 8 GB RAM  (burstable, great for learning)
  # node_count = 2  →  this creates exactly 2 VMs in the subnet.
  default_node_pool {
    name           = "systempool"
    node_count     = var.node_count       # 2
    vm_size        = var.vm_size          # "Standard_B2ms"
    vnet_subnet_id = azurerm_subnet.aks_nodes.id

    # OS disk type: Managed (persists) vs Ephemeral (faster, cheaper for dev)
    os_disk_type = "Managed"
    os_disk_size_gb = 30

  }

  # ── Networking ─────────────────────────────────────────────
  network_profile {
    network_plugin = "kubenet"
    pod_cidr       = var.pod_cidr           # 10.244.0.0/16  (overlay)
    service_cidr   = var.service_cidr       # 10.0.2.0/24
    dns_service_ip = var.dns_service_ip     # 10.0.2.10
  }

  # ── Identity ───────────────────────────────────────────────
  # SystemAssigned = Azure creates a managed identity for the cluster.
  # No passwords or client secrets to rotate!
  identity {
    type = "SystemAssigned"
  }

  # ── RBAC / AAD (optional but recommended) ──────────────────
  role_based_access_control_enabled = true

  tags = var.tags
}
