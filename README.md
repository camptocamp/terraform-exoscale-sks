# terraform-exoscale-sks

A terraform module to create a managed Kubernetes cluster on Exoscale SKS.

## Usage example

```hcl
module "sks" {
  source  = "camptocamp/sks/exoscale"
  version = "0.3.0"

  name = "test"
  zone = "de-fra-1"

  nodepools = {
    "router" = {
      instance_type = "medium"
      size          = 2
    },
    "compute" = {
      instance_type = "small"
      size          = 3
    }
  }
}
```
