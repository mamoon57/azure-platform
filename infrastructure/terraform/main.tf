terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "sttfstate"
  #   container_name       = "tfstate"
  #   key                  = "platform.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

module "network" {
  source = "../modules/network"

  project     = var.project
  environment = var.environment
  location    = var.location
  vnet_cidr   = var.vnet_cidr
}

module "compute" {
  source = "../modules/compute"

  project             = var.project
  environment         = var.environment
  location            = var.location
  resource_group_name = module.network.resource_group_name
  subnet_id           = module.network.app_subnet_id
  app_service_sku     = var.app_service_sku
}
