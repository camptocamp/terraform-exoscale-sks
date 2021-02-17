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

resource "null_resource" "wait_for_cluster" {
  depends_on = [
    exoscale_sks_cluster.this,
  ]

  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter

    environment = {
      ENDPOINT = exoscale_sks_cluster.this.endpoint
    }
  }
}

data "external" "kubeconfig" {
  program = ["sh", "${path.module}/kubeconfig.sh"]

  query = {
    cluster_name = var.name
    zone         = var.zone
  }
}
