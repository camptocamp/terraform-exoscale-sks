resource "exoscale_sks_cluster" "this" {
  zone    = var.zone
  name    = var.name
  version = var.kubernetes_version
}

resource "exoscale_affinity" "this" {
  for_each = var.nodepools

  name = format("nodepool-%s-%s", var.name, each.key)
  type = "host anti-affinity"
}

resource "exoscale_security_group" "this" {
  name = format("nodepool-%s", var.name)
}

resource "exoscale_security_group_rule" "nodeport_services" {
  count = var.node_ports_world_accessible ? 1 : 0

  security_group_id = exoscale_security_group.this.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 30000
  end_port          = 32767
}

resource "exoscale_security_group_rule" "sks_logs" {
  security_group_id = exoscale_security_group.this.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 10250
  end_port          = 10250
}

resource "exoscale_security_group_rule" "calico_traffic" {
  security_group_id      = exoscale_security_group.this.id
  type                   = "INGRESS"
  protocol               = "UDP"
  user_security_group_id = exoscale_security_group.this.id
  start_port             = 4789
  end_port               = 4789
}

resource "exoscale_sks_nodepool" "this" {
  for_each = var.nodepools

  zone          = var.zone
  cluster_id    = exoscale_sks_cluster.this.id
  name          = each.key
  instance_type = each.value.instance_type
  size          = each.value.size

  anti_affinity_group_ids = [exoscale_affinity.this[each.key].id]
  security_group_ids      = [exoscale_security_group.this.id]
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
    cluster_id = exoscale_sks_cluster.this.id
    zone       = var.zone
  }
}
