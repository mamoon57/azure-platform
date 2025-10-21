output "web_app_url" {
  value = "https://${azurerm_linux_web_app.web.default_hostname}"
}

output "function_app_url" {
  value = "https://${azurerm_linux_function_app.worker.default_hostname}"
}
