variable "project" {
  type        = string
  description = "Short project name used in resource naming"
  default     = "shop"
}

variable "environment" {
  type        = string
  description = "dev, test, or prod"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "uksouth"
}

variable "app_service_sku" {
  type        = string
  description = "App Service plan SKU"
  default     = "B1"
}
