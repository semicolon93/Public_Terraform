provider "azurerm" {
  features {}
}
#Fetching existing resource group where the resource will be deployed
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
#Fetching existing virtual network
data "azurerm_virtual_network" "vnet_rg" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg
}
#Fetching details of the existing subscription and account used to login
data "azurerm_client_config" "current" {

}
#Creating managed user identity
resource "azurerm_user_assigned_identity" "managed_user" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  name = var.managed_identity_name
}
/*
resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = var.keyvault_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_user_assigned_identity.managed_user.principal_id

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]

  certificate_permissions = [
    "get",
  ]
}

data "azurerm_key_vault_certificate" "appgw_sslcertificate" {
  name = var.appgw_kv_sslcertificate_name
  key_vault_id = var.keyvault_id
}

data "azurerm_key_vault_secret" "appgw_trustedrootcertificate" {
  name = var.appgw_kv_trustedrootcertificate_name
  key_vault_id = var.keyvault_id
}
*/
