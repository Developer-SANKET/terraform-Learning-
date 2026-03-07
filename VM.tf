terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-Sam"
  location = "East US 2"

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

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "pip" {
  for_each = tomap(({ LinuxVM1 = "demo-public-ip-1", LinuxVM2 = "demo-public-ip-2" }))
  name                = "${each.key}-public-ip" # using for_each to assign unique names to each instance
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  for_each = tomap(({ LinuxVM1 = "demo-nic-1", LinuxVM2 = "demo-nic-2" }))
  name                = "${each.key}-nic" # using for_each to assign unique names to each instance
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  for_each = tomap({ LinuxVM1 = "Standard_B1s", LinuxVM2 = "Standard_B2s" }) # meta argument to create multiple instances with different sizes
  //#count = 2 # meta argument to create multiple instances
  name                = each.key # using for_each to assign unique names to each instance
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = each.value # using variable to assign sizes based on the instance
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  admin_ssh_key {
    username   = "azureuser"  
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCc8ghg9R9EbSTiLAuTDzxs4CZSnNIBUhXJQ30a7iAI6nHU9sV/Utv0wDYEIkeBJGfT1g6kNVTi9cPdr1GaV98Jvvb2I5iclrtDKRviPTZLfGzZFRtPbuwtfBrhc7eD+iCX9I0nC/OnDfuswz4il09ZIKbH1/51v53GUE5hRpzRo/mr+ncVxz6VMisw1giJpARh8VobTvQtirk7ulZOiF9vMcRHGQukQF68Y3EUOUtej3kHr5YBqQlIKiL3+5z/29BQZfSq2LXQicOaQCOxbRw/3DRtqeJvVu4kPzd5zo0cb6SAo2c9kp2Gx3ZMXL8YgaJomh+qZBVYYJwYjQT2GaeN5rJnQbx6RljVLQgwV9InhtiIhh2a2zq88/adYciLUm36FO0qd1jXyb4pCVa7Zib5VGbV7FU8oviU0IEjIZLixLHgqHZgqpDoj2ndkikaiNrPMKr/LASGq0Kpl8fLL49OGvEbQGOCjGfWYcKcvPQBy4YpQonr6B4JfLSjRaZh7JqAfbatqQv/rOQv4bWUnWhdd9WHyiaiNT3vnn46acg0lmxfwzKyzRP8BSUhBVbXa4T6d+hHaChZakVA1csgWoyNPeTr48cz8C6i1dDMoXiiAT9GJO89skIdpW7DIKBDeBYkV2w+6VVDGSsC5fqZeCFPpx7khF6Lw4dn6aFnU5JAiw=="
    
  }
 user_data = base64encode(file("install_ngnix.sh"))

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
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