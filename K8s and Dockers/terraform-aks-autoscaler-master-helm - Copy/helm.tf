provider "helm" {
  kubernetes {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  load_config_file = false
  } 
}

resource "helm_release" "wordpress" {
  name       = "wordpress"
  chart      = "./helm/wordpress"
  values = [
    "${file("./helm/wordpress/values.yaml")}"
  ]

  
  set {
    name  = "mariadb.enabled"
    value = "false"
  }

  set_string {
      name = "externalDatabase.host"
      value = azurerm_mysql_server.blogdb.fqdn
  }
  set_string {
      name = "externalDatabase.user"
      value = "${azurerm_mysql_server.blogdb.administrator_login}@${azurerm_mysql_server.blogdb.name}"
  }
  set_string {
      name = "externalDatabase.password"
      value = azurerm_mysql_server.blogdb.administrator_login_password
  }
  set_string {
      name = "externalDatabase.database"
      value = azurerm_mysql_database.blogdb.name
  }
}