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
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "security" {
  name     = "rg-${var.project}-security-${var.environment}"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.project}-sec-${var.environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.security.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8, 1)]
}

resource "azurerm_subnet" "app_gateway" {
  name                 = "snet-appgw"
  resource_group_name  = azurerm_resource_group.security.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet_cidr, 8, 2)]
}

resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.project}-${var.environment}"
  location                   = azurerm_resource_group.security.location
  resource_group_name        = azurerm_resource_group.security.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = var.environment == "prod"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

resource "azurerm_private_endpoint" "vault" {
  name                = "pe-kv-${var.environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "kv-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

resource "azurerm_web_application_firewall_policy" "edge" {
  name                = "waf-${var.project}-${var.environment}"
  location            = azurerm_resource_group.security.location
  resource_group_name = azurerm_resource_group.security.name

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
}

# attach this policy to App Gateway or Front Door in the application stack
resource "azurerm_security_center_subscription_pricing" "defender" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_appservices" {
  tier          = "Standard"
  resource_type = "AppServices"
}

resource "azurerm_security_center_subscription_pricing" "defender_sql" {
  tier          = "Standard"
  resource_type = "SqlServers"
}

resource "azurerm_subscription_policy_definition" "require_environment_tag" {
  name         = "require-environment-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require Environment tag on resources"

  policy_rule = jsonencode({
    if = {
      field     = "tags['Environment']"
      exists    = false
    }
    then = {
      effect = "deny"
    }
  })
}
