# ============================================================
# variables.tf — all tunable knobs in one place
# ============================================================
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-aks-demo"
}

variable "location" {
  description = "Azure region (e.g. eastus, westeurope, southeastasia)"
  type        = string
  default     = "East US"
}

variable "cluster_name" {
  description = "AKS cluster name — also used to name the VNet"
  type        = string
  default     = "aks-demo"
}

# ── VM sizing ──
# Standard_B2ms: 2 vCPU, 8 GB RAM, burstable
# Upgrade options: Standard_D2s_v3, Standard_D4s_v3
variable "vm_size" {
  description = "VM size for each AKS node"
  type        = string
  default     = "Standard_B2ms"
}

variable "node_count" {
  description = "Number of nodes in the default node pool (we want 2)"
  type        = number
  default     = 2
}


variable "vnet_cidr" {
  description = "Address space for the Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR for AKS nodes (must be inside vnet_cidr)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "pod_cidr" {
  description = "CIDR for pod IPs (kubenet overlay — must NOT overlap vnet_cidr)"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services (ClusterIP range)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "dns_service_ip" {
  description = "IP for the K8s DNS service — must be inside service_cidr"
  type        = string
  default     = "10.0.2.10"
}

# ── Tags ───────────────────────────────────────────────────
variable "tags" {
  description = "Tags applied to all resources (great for cost tracking)"
  type        = map(string)
  default = {
    WorkloadName              = "TerraformLearning"
    Environment               = "Prod"
    RequestedByEmail          = "Sharath.Potla@genzeon.com"
    InfrastructureOwnerEmail  = "Sharat.Potla@genzeon.com"
    BusinessOwnerEmail        = "Vikram.Pendli@genzeon.com"
    BudgetApproved            = "Prod"
    ApprovedByEmail           = "Vikram.Pendli@genzeon.com"
    BusinessUnit              = "Prod"
    CreatedByEmail            = "Sanket.Patil@genzeon.com"
    ApplicationOwnerEmail     = "susheel.nayakula@genzeon.com"
    DataClassification        = "azure-cloud-shell"
  }
}
