provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
  }
}

module "module_aks" {
    source = ".//module_aks"
    environment             = var.environment
    resource_group_name     = var.resource_group_name
    location                = "East US"
    vnet_name               = var.vnet_name
    vnet_rg                 = var.vnet_rg
    aks_subnet_name         = var.aks_subnet_name
    aks_subnet_address_cidr = var.aks_subnet_address_cidr
    aks_name                = var.aks_name
    aks_dns_prefix          = var.aks_dns_prefix
    kubernetes_version      = var.kubernetes_version
    aks_default_node_pool_name = var.aks_default_node_pool_name
    aks_default_node_pool_count = var.aks_default_node_pool_count
    aks_default_node_pool_vm_size = var.aks_default_node_pool_vm_size
    aks_default_node_pool_type = var.aks_default_node_pool_type
    aks_network_plugin = var.aks_network_plugin
    aks_dns_service_ip = var.aks_dns_service_ip
    aks_docker_bridge_cidr = var.aks_docker_bridge_cidr
    aks_load_balancer_sku = var.aks_load_balancer_sku
    aks_service_cidr = var.aks_service_cidr
    aks_nsg_rule_file = var.aks_nsg_rule_file
    enable_log_analytics_workspace = var.enable_log_analytics_workspace
    log_analytics_workspace_sku = var.log_analytics_workspace_sku
    log_retention_in_days = var.log_retention_in_days
    aks_service_principal_client_id = var.aks_service_principal_client_id
    aks_node_pool = var.aks_node_pool
    key_vault_name = var.key_vault_name
    key_vault_rg_name = var.key_vault_rg_name
    key_vault_aks_service_secret_name = var.key_vault_aks_service_secret_name
}

   