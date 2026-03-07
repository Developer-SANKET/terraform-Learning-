#output "public_ip_address" {
 # value = azurerm_public_ip.pip[*].ip_address
#}

#output "azurevm_dns_ip_address" {
 # value = azurerm_public_ip.pip[*].fqdn
  #description = "Public DNS name for VM"
#}

#output "azurevm_id" {
 # value = azurerm_linux_virtual_machine.vm[*].id
#}


# Output for each VM's public IP address using for_each

output "public_ip_address" {
  value = {
    for key, pip in azurerm_public_ip.pip : key => pip.ip_address
  }
}