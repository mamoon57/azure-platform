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

resource "azurerm_resource_group" "monitoring" {
  name     = "rg-${var.project}-monitoring-${var.environment}"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.project}-${var.environment}"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

resource "azurerm_application_insights" "app" {
  name                = "appi-${var.project}-${var.environment}"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
}

resource "azurerm_monitor_action_group" "ops" {
  name                = "ag-${var.project}-ops"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "ops"

  email_receiver {
    name          = "platform-team"
    email_address = var.alert_email
  }
}

resource "azurerm_monitor_metric_alert" "high_error_rate" {
  name                = "alert-high-errors-${var.environment}"
  resource_group_name = azurerm_resource_group.monitoring.name
  scopes              = [azurerm_application_insights.app.id]
  description         = "Error rate above threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "exceptions/count"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.ops.id
  }
}
