resource "azurerm_storage_account" "blob" {
  name                     = "terrasanket70423"
  resource_group_name      = "rg-Sanket"
  location                 = "East US 2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
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