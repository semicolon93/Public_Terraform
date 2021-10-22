provider "azurerm" {
    features {}
}

data "azurerm_resource_group" "vpngw_rg"{ 
  name= var.vnet_rg
}

data "azurerm_key_vault" "vpn_kv" {
  name                = var.kv_name
  resource_group_name = var.kv_rg_name
}

# Variable for Certificate Name
locals {
  certificate-name = "BVMTest-RootCert.crt"
}

# Create a Secret for the VPN Root certificate
resource "azurerm_key_vault_secret" "vpn-root-certificate" {
  depends_on=[data.azurerm_key_vault.vpn_kv]
  name = "vpn-root-certificate"
  value = filebase64(local.certificate-name)
  key_vault_id = data.azurerm_key_vault.vpn_kv.id
}
