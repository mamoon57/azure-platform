variable "project" {
  type    = string
  default = "shop"
}

variable "environment" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "vnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}
