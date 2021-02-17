resource "exoscale_sks_cluster" "cluster" {
  zone    = var.zone
  name    = "prod"
  version = var.kubernetes_version
}

resource "exoscale_sks_nodepool" "nodepool" {
  for_each = var.nodepools

  zone          = var.zone
  cluster_id    = exoscale_sks_cluster.cluster.id
  name          = each.key
  instance_type = each.value.instance_type
  size          = each.value.size
}
