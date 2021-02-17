output "kubeconfig" {
  description = "kubectl config file contents for this SKS cluster."
  value       = data.external.kubeconfig.result.kubeconfig
  sensitive   = true
}

output "nodepools" {
  value = exoscale_sks_nodepool.this
}
