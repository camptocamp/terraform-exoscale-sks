output "kubeconfig" {
  description = "kubectl config file contents for this SKS cluster."
  value       = data.external.kubeconfig.result.kubeconfig
  sensitive   = true
}
