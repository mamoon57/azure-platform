output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "waf_policy_id" {
  value = azurerm_web_application_firewall_policy.edge.id
}

output "private_endpoint_vault_id" {
  value = azurerm_private_endpoint.vault.id
}
