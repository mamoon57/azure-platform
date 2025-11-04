output "apim_gateway_url" {
  value = azurerm_api_management.gateway.gateway_url
}

output "servicebus_namespace" {
  value = azurerm_servicebus_namespace.messaging.name
}

output "servicebus_connection_string" {
  value     = azurerm_servicebus_namespace.messaging.default_primary_connection_string
  sensitive = true
}
