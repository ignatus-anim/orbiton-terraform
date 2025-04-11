resource "kubernetes_deployment" "app" {
  metadata {
    name = "${var.project_name}-${var.environment}-deployment"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = var.project_name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.project_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.project_name
        }
      }

      spec {
        container {
          image = var.container_image
          name  = "${var.project_name}-container"

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = "${var.project_name}-${var.environment}"
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "${var.project_name}-${var.environment}-service"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = var.project_name
    }

    port {
      port        = 80
      target_port = var.container_port
    }

    type = "LoadBalancer"
  }
}