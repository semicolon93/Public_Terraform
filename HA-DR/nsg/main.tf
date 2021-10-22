provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name = "RG_TF"
    storage_account_name = "storageaccounttf01"
    container_name = "container01"
    key = "DesktopSubnet-nsg.tfstate"
  }
}

#module to create nsg and network security rules
module "nsg" {
    source = ".//module_nsg"

    location = var.location
    nsg_rules_file = var.nsg_rules_file
    nsg_name = var.nsg_name
    vnet_rg_name = var.vnet_rg_name
    vnet_name = var.vnet_name
    subnet_name = var.subnet_name
    subnet_cidr = var.subnet_cidr
#    dependency = module.appgw.dependency
}