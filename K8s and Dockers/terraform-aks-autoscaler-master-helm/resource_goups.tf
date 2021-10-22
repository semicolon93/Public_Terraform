terraform {
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.aks.kube_config[0].host

  client_certificate = base64decode(
    azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate,
  )
  client_key = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(
    azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate,
  )
}


resource "azurerm_resource_group" "main" {
  name     = var.main_resource_group
  location = var.main_resource_group_location
}

data "azurerm_key_vault" "kv" {
  name                = var.kv_name
  resource_group_name = var.kv_rg
}

data "azurerm_key_vault_secret" "sqldb-password" {
  name         = var.sqldb_password_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "wordpress_password" {
  name         = var.wordpress_Password_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = var.client_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}