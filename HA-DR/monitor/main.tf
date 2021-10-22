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

module "nsg" {
    source = ".//module_monitor"
    environment = var.environment
    resource_group_name = var.resource_group_name
    action_group_name =var.action_group_name
    action_group_short_name = var.action_group_short_name
    user_name = var.user_name
    user_mail_address = var.user_mail_address
    application_insight_name = var.application_insight_name
}