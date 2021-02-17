variable "kubernetes_version" {
  type    = string
  default = "1.20.2"
}

variable "zone" {
  description = "The name of the zone to deploy the SKS cluster into."
  type        = string
}

variable "nodepools" {
  description = "The SKS node pools to create."
  type        = map(any)
}
