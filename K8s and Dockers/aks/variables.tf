variable "environment" {
  type = string
}

variable "resource_group_name" {
    type = string
}

variable "location" {}
variable "vnet_name" {
  type = string
}

variable "vnet_rg" {
  type = string
}

variable "aks_subnet_name" {
    type = string
}

variable "aks_subnet_address_cidr" {
    type = list
}

variable "aks_name" {
    type = string
}

variable "aks_dns_prefix" {}
variable "kubernetes_version" {}
variable "aks_default_node_pool_name" {}
variable "aks_default_node_pool_count" {}
variable "aks_default_node_pool_vm_size" {}
variable "aks_default_node_pool_type" {}
variable "aks_network_plugin" {}
variable "aks_dns_service_ip" {}
variable "aks_docker_bridge_cidr" {}
variable "aks_load_balancer_sku" {}
variable "aks_service_cidr" {}
variable "aks_nsg_rule_file" {}
variable "enable_log_analytics_workspace" {}
variable "log_analytics_workspace_sku" {}
variable "log_retention_in_days" {}
variable "aks_service_principal_client_id" {}
variable "aks_node_pool" {}
variable "key_vault_name" {}
variable "key_vault_rg_name" {}
variable "key_vault_aks_service_secret_name" {}
