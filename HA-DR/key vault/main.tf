provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    #resource_group_name = "RG_TF"
    #storage_account_name = "storageaccounttf01"
    #container_name = "container01"
    #key = "vnet_snet.tfstate"
  }
}

module "module_kv" {
    source = ".//module_kv"
    environment = var.environment
    kv_rg_name = var.kv_rg_name
    kv_name = var.kv_name
    sku = var.sku
    enabled_for_deployment = var.enabled_for_deployment
    enabled_for_disk_encryption = var.enabled_for_disk_encryption
    enabled_for_template_deployment = var.enabled_for_template_deployment
    network_acls = var.network_acls

}