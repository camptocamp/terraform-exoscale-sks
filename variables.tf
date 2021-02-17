variable "name" {
  description = "The name of the SKS cluster."
  type        = string
}

variable "zone" {
  description = "The name of the zone to deploy the SKS cluster into."
  type        = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.20.2"
}

variable "nodepools" {
  description = "The SKS node pools to create."
  type        = map(any)
}
