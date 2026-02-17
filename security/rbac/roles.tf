variable "subscription_id" {
  type = string
}

variable "resource_group_id" {
  type = string
}

resource "azurerm_role_definition" "deployer" {
  name        = "Platform Deployer"
  scope       = var.subscription_id
  description = "Can deploy and manage app resources but not touch Key Vault secrets"

  permissions {
    actions = [
      "Microsoft.Resources/deployments/*",
      "Microsoft.Web/sites/*",
      "Microsoft.Web/serverfarms/*",
      "Microsoft.Insights/components/*",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/subnets/read",
    ]
    not_actions = [
      "Microsoft.KeyVault/vaults/secrets/*",
      "Microsoft.Authorization/roleAssignments/*",
    ]
  }

  assignable_scopes = [
    var.resource_group_id,
  ]
}

resource "azurerm_role_assignment" "pipeline_deployer" {
  scope              = var.resource_group_id
  role_definition_id = azurerm_role_definition.deployer.role_definition_resource_id
  principal_id       = var.pipeline_principal_id
}

variable "pipeline_principal_id" {
  type = string
}
