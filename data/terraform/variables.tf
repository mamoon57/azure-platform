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

variable "secondary_location" {
  type    = string
  default = "ukwest"
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "sql_sku" {
  type    = string
  default = "S0"
}

variable "storage_replication" {
  type    = string
  default = "GRS"
}
