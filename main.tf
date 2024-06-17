provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  aks_name            = var.aks_name
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
}

output "aks_name" {
  value = module.aks.aks_name
}
