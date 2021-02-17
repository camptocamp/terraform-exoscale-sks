resource "exoscale_sks_cluster" "this" {
  zone    = var.zone
  name    = var.name
  version = var.kubernetes_version
}

resource "exoscale_sks_nodepool" "this" {
  for_each = var.nodepools

  zone          = var.zone
  cluster_id    = exoscale_sks_cluster.this.id
  name          = each.key
  instance_type = each.value.instance_type
  size          = each.value.size
}
