provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_name           = var.vnet_name
  subnet_name         = var.subnet_name
  address_space       = var.address_space
  subnet_prefix       = var.subnet_prefix
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  aks_name            = var.aks_name
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  subnet_id           = module.network.subnet_id
}

output "aks_name" {
  value = module.aks.aks_name
}

output "subnet_id" {
  value = module.network.subnet_id
}
