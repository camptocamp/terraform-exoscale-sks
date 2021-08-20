# terraform-exoscale-sks

A terraform module to create a managed Kubernetes cluster on Exoscale SKS.

This module creates an SKS cluster with one or more node pools. It creates one security group for all instances with the minimum rules recommended in the exoscale documentation. It also creates one anti-affinity group for each node pool. It then automatically retrieves the kubeconfig that allows access to the cluster.


## Usage example

```hcl
module "sks" {
  source  = "camptocamp/sks/exoscale"
  version = "0.3.1"

  name = "test"
  zone = "de-fra-1"

  kubernetes_version = "1.21.3"

  nodepools = {
    "router" = {
      instance_type = "standard.medium"
      size          = 2
    },
    "compute" = {
      instance_type = "standard.small"
      size          = 3
    }
  }
}
```
