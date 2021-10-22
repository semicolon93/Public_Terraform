provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_service.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks_service.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks_service.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_service.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_service.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_service.kube_config.0.cluster_ca_certificate)
  load_config_file = false
}

provider "helm" {
  kubernetes {
  host                   = azurerm_kubernetes_cluster.aks_service.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks_service.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks_service.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_service.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_service.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_service.kube_config.0.cluster_ca_certificate)
  load_config_file = false
  } 
}
/*
resource "kubernetes_namespace" "clock" {
  metadata {
    annotations = {
      name = "clock"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "terraform-clock-app"
  }
  depends_on = [azurerm_kubernetes_cluster.aks_service]
}
*/

resource "helm_release" "wordpress"{
    name = "wordpress"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "wordpress"
    namespace = "wordpress"
    create_namespace = true
    values = [
      "${file("values.yaml")}"
    ]
    depends_on = [azurerm_kubernetes_cluster.aks_service]
  }
  
 /* resource "kubernetes_deployment" "MyDeploy" {
metadata {
name = "wordpress"
labels = {
App = "MyApp"
}
}
spec {
replicas = 1   
selector {
match_labels = {
App = "MyApp"
}
}
template {
metadata {
labels = {
App = "MyApp"
}
}
spec {
container {
image = "wordpress"
name  = "my-wordpress"
port {
container_port = 80
 }
}
}
}
}
}

resource "kubernetes_service" "service" {
depends_on = [kubernetes_deployment.MyDeploy]
metadata {
name = "my-service"
}
spec {
selector = {
App = kubernetes_deployment.MyDeploy.metadata.0.labels.App
}
port {
#node_port   = 30202
port        = 80
target_port = 80
}
type = "LoadBalancer"
}
}
*/