output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "app_insights_connection_string" {
  value     = azurerm_application_insights.app.connection_string
  sensitive = true
}

output "app_insights_instrumentation_key" {
  value     = azurerm_application_insights.app.instrumentation_key
  sensitive = true
}
