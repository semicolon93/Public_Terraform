locals { 
    url = format("wordpressbvm.%s", azurerm_kubernetes_cluster.aks.addon_profile[0].http_application_routing[0].http_application_routing_zone_name)
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "wordpress"
    namespace = "wordpress"
    annotations = {
        "kubernetes.io/ingress.class" = "addon-http-application-routing"}

  }

  spec {
    backend {
      service_name = "wordpress"
      service_port = 80
    }

    rule {
      host = local.url
      http {
        path {
          backend {
            service_name = "wordpress"
            service_port = 80
          }

          path = "/"
        }
      }
    }
  }
  depends_on = [helm_release.wordpress]
}

output "wordpress_url" {
  value = local.url
}