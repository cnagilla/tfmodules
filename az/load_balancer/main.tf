module "public_ip" {
  source = "../public_ip"

  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
}

resource "azurerm_lb" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                 = var.public_ip_name
    public_ip_address_id = module.public_ip.id
  }

  tags = var.tags
}