provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

#Fetching existing resource group where the resource will be deployed
data "azurerm_resource_group" "aks_rg" {
  name = var.resource_group_name
}

#Fetching the service principal sercret stored in Key vault
data "azurerm_key_vault" "key_vault" {
  name = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

data "azurerm_key_vault_secret" "aks_service_principal_client_secret" {
  name              = var.key_vault_aks_service_secret_name
  key_vault_id      = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_container_registry" "aks_acr" {
  name                = "bvmregistry"
  resource_group_name = data.azurerm_resource_group.aks_rg.name
  location            = data.azurerm_resource_group.aks_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "aks_acr_role" {
  scope              = azurerm_container_registry.aks_acr.id
  role_definition_name = "AcrPull"
  principal_id       = "1562b4a3-f9b6-47bf-98ed-0d35cf75e5c5"
  skip_service_principal_aad_check = true
}
