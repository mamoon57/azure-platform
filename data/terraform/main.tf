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

resource "azurerm_resource_group" "data" {
  name     = "rg-${var.project}-data-${var.environment}"
  location = var.location
}

resource "azurerm_mssql_server" "primary" {
  name                         = "sql-${var.project}-${var.environment}"
  location                     = azurerm_resource_group.data.location
  resource_group_name          = azurerm_resource_group.data.name
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "app" {
  name      = "sqldb-${var.project}"
  server_id = azurerm_mssql_server.primary.id
  sku_name  = var.sql_sku
}

# secondary region for geo-replication / failover
resource "azurerm_resource_group" "data_secondary" {
  name     = "rg-${var.project}-data-${var.environment}-dr"
  location = var.secondary_location
}

resource "azurerm_mssql_server" "secondary" {
  name                         = "sql-${var.project}-${var.environment}-dr"
  location                     = azurerm_resource_group.data_secondary.location
  resource_group_name          = azurerm_resource_group.data_secondary.name
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "app_secondary" {
  name                        = "sqldb-${var.project}"
  server_id                   = azurerm_mssql_server.secondary.id
  sku_name                    = var.sql_sku
  create_mode                 = "OnlineSecondary"
  creation_source_database_id = azurerm_mssql_database.app.id
}

resource "azurerm_mssql_failover_group" "app" {
  name      = "fog-${var.project}-${var.environment}"
  server_id = azurerm_mssql_server.primary.id

  partner_server {
    id = azurerm_mssql_server.secondary.id
  }

  readonly_endpoint_failover_policy {
    grace_minutes = 60
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_account" "images" {
  name                     = "stimg${var.project}${var.environment}"
  location                 = azurerm_resource_group.data.location
  resource_group_name      = azurerm_resource_group.data.name
  account_tier             = "Standard"
  account_replication_type = var.storage_replication
}

resource "azurerm_storage_container" "product_images" {
  name                  = "product-images"
  storage_account_name  = azurerm_storage_account.images.name
  container_access_type = "blob"
}
