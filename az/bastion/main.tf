module "public_ip" {
  source = "../public_ip"

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  ip_configuration {
    name                 = module.public_ip.name
    subnet_id            = var.subnet_id
    public_ip_address_id = module.public_ip.id
  }

  tags = var.tags
}