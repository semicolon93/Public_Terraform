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

