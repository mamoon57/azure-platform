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

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "alert_email" {
  type = string
}
