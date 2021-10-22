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


module "log_analytics" {
  source = ".//module_log_analytics"
  environment = var.environment
  resource_group_name = var.resource_group_name
  log_analytics_workspace_name = var.log_analytics_workspace_name
  solution_name = var.solution_name
  solution_product =var.solution_product
  }