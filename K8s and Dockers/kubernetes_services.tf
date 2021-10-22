resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      App = "wordpress"
    }
  }

  spec {
    selector = {
      App = kubernetes_replication_controller.wordpress.metadata[0].labels.App
    }

    session_affinity = "ClientIP"

    port {
      port        = 80
      #target_port = 80
    }

    type = "ClusterIP"
  }
}

output "wordpress_ip" {
  value = kubernetes_service.wordpress.load_balancer_ingress.*.ip
}

