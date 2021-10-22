resource "kubernetes_horizontal_pod_autoscaler" "wordpress" {
  metadata {
    name = "wordpress"
    namespace = "wordpress"
  }

  spec {
    max_replicas = 300
    min_replicas = 1
    target_cpu_utilization_percentage = 5
    scale_target_ref {
      kind = "ReplicationController"
      name = "wordpress"
    }
  }

  depends_on = [null_resource.kubernetes_config_autoscaler, helm_release.wordpress]
}

