output "failover_group_listener" {
  value = azurerm_mssql_failover_group.app.name
}

output "images_container_url" {
  value = "${azurerm_storage_account.images.primary_blob_endpoint}${azurerm_storage_container.product_images.name}/"
}

output "storage_connection_string" {
  value     = azurerm_storage_account.images.primary_connection_string
  sensitive = true
}
