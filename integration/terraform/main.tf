terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "integration" {
  name     = "rg-${var.project}-integration-${var.environment}"
  location = var.location
}

resource "azurerm_api_management" "gateway" {
  name                = "apim-${var.project}-${var.environment}"
  location            = azurerm_resource_group.integration.location
  resource_group_name = azurerm_resource_group.integration.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku
}

resource "azurerm_servicebus_namespace" "messaging" {
  name                = "sb-${var.project}-${var.environment}"
  location            = azurerm_resource_group.integration.location
  resource_group_name = azurerm_resource_group.integration.name
  sku                 = var.servicebus_sku
}

resource "azurerm_servicebus_queue" "orders" {
  name         = "orders"
  namespace_id = azurerm_servicebus_namespace.messaging.id
}

resource "azurerm_servicebus_topic" "notifications" {
  name         = "notifications"
  namespace_id = azurerm_servicebus_namespace.messaging.id
}

resource "azurerm_servicebus_subscription" "email" {
  name               = "email-handler"
  topic_id           = azurerm_servicebus_topic.notifications.id
  max_delivery_count = 10
}
