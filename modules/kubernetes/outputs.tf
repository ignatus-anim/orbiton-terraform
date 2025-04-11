output "service_endpoint" {
  value = kubernetes_service.app.status[0].load_balancer[0].ingress[0].hostname
}

output "namespace" {
  value = kubernetes_namespace.app.metadata[0].name
}