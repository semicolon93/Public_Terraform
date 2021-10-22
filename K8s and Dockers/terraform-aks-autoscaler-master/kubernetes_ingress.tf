locals { 
    url = format("wordpressbvm.%s", azurerm_kubernetes_cluster.aks.addon_profile[0].http_application_routing[0].http_application_routing_zone_name)
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "wordpress"
    annotations = {
        "kubernetes.io/ingress.class" = "addon-http-application-routing"}

  }

  spec {
    backend {
      service_name = kubernetes_service.wordpress.metadata[0].labels.App
      service_port = 80
    }

    rule {
      host = local.url
      http {
        path {
          backend {
            service_name = kubernetes_service.wordpress.metadata[0].labels.App
            service_port = 80
          }

          path = "/"
        }
      }
    }
  }
}

output "ingress_ip" {
  value = local.url
}