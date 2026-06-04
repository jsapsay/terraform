terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "a41f28c0-67f8-4488-9be9-9d02191f59a1"
  features {}
}

resource "azurerm_resource_group" "learning" {
  name     = "rg-learning-dev-eastus-001"
  location = "East US"
}

resource "azurerm_storage_account" "learning" {
  name                     = "stlearningjon001"
  resource_group_name      = azurerm_resource_group.learning.name
  location                 = azurerm_resource_group.learning.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_kubernetes_cluster" "learning" {
  name                = "aks-learning-dev-eastus-001"
  location            = azurerm_resource_group.learning.location
  resource_group_name = azurerm_resource_group.learning.name
  dns_prefix          = "akslearning"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DC2as_v5"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.learning.kube_config_raw
  sensitive = true
}