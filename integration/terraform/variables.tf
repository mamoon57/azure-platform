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

variable "apim_publisher_name" {
  type    = string
  default = "Platform Team"
}

variable "apim_publisher_email" {
  type = string
}

variable "apim_sku" {
  type    = string
  default = "Developer_1"
}

variable "servicebus_sku" {
  type    = string
  default = "Standard"
}
