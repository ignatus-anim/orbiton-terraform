
output "kubernetes_app_endpoint" {
  value = module.kubernetes_deployment.service_endpoint
}

output "kubernetes_namespace" {
  value = module.kubernetes_deployment.namespace
}

