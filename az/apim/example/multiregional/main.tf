resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "cus" {
  name     = "rg-${var.name}-${random_string.this.result}-cus"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "cus" {
  name                = "vnet-${var.name}-${random_string.this.result}-cus"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name
  tags                = var.tags
}

resource "azurerm_subnet" "apim_cus" {
  name                 = "snet-${var.name}-${random_string.this.result}-apim"
  resource_group_name  = azurerm_resource_group.cus.name
  virtual_network_name = azurerm_virtual_network.cus.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "bastion_cus" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.cus.name
  virtual_network_name = azurerm_virtual_network.cus.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "vm_cus" {
  name                 = "snet-${var.name}-${random_string.this.result}-vm"
  resource_group_name  = azurerm_resource_group.cus.name
  virtual_network_name = azurerm_virtual_network.cus.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "bastion_cus" {
  name                = "pip-${var.name}-${random_string.this.result}-bastion"
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_cus" {
  name                = "bas-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name

  ip_configuration {
    name                 = "ifcfg-${var.name}-${random_string.this.result}-bas"
    subnet_id            = azurerm_subnet.bastion_cus.id
    public_ip_address_id = azurerm_public_ip.bastion_cus.id
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "apim_cus" {
  name                = "nsg-${var.name}-${random_string.this.result}-apim"
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name

  security_rule {
    name                       = "allow_api_management"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow_lb"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6390"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow_outbound_storage"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "allow_outbound_sql"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
  }

  security_rule {
    name                       = "allow_outbound_key_vault"
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  }
}

resource "azurerm_subnet_network_security_group_association" "apim_cus" {
  subnet_id                 = azurerm_subnet.apim_cus.id
  network_security_group_id = azurerm_network_security_group.apim_cus.id
}

resource "azurerm_network_interface" "jump_cus" {
  name                = "nic-${var.name}${random_string.this.result}jump"
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name

  ip_configuration {
    name                          = "ifcfg-${var.name}-${random_string.this.result}-jump"
    subnet_id                     = azurerm_subnet.vm_cus.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jump_cus" {
  name                  = "vm${var.name}${random_string.this.result}jump"
  location              = azurerm_resource_group.cus.location
  resource_group_name   = azurerm_resource_group.cus.name
  size                  = "Standard_DS2_v2"
  admin_username        = "sysops"
  network_interface_ids = [azurerm_network_interface.jump_cus.id]

  admin_ssh_key {
    username   = "sysops"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIB6sSBzkec8QhrkL7i91hiqQtN7Vmfh9OYvvYXS/3myDo0E3FaWZKqFs4JFAUynze9EPlKY7yZdE1NIFZGlVP4+a9v0uSQ2y/MB/GmVQ/afQ8yYlLTEL4zYZ5a0N736lz4bXhb0eCYkMN/Tgrqo1/6b3EjS9zIQAdZD8f6uG0HBxWTaKvuDRrhlMT1c7S9rFLog2vIC/LMxHABaVPOCP38+VCoS4Iq3RCs3B/hZ8hogKHtnxwNE83CrCDH4SJ6nf9eKtj2PQXRbX9LbKcgRXwIHDzuO7CZ1VVexF6DMaRb6Xs+ADYr4QVtvZtbp2hq7ldx/cGRHPpjlkx4dpYPtX1K54EGrO45DSFYfA99VU2q0I56Af6kHUGHqJZyJh4E1/Z9ws+W43eiiidc9545zFHIZAi9xYxJ1NospfjFRn9C1smn1jw0WRmLTjxD30jfyOdZVe+BdTgxaQtNN8ZbJbTM8a5Lo3cxFa+2RIGxzvW8ZFWXOREkmwiyr/Ef2VCoXgp8zGc3REyQnj+s1kWBzQudoQ3yhZtD8nCbt5oN6s4/lFVGxO91fqR8AQqvtXUpDlTI9UhV8dFXO2c1UvmnvDGr8ZU50dyeutv9fIPXuFZKXsX+LigISzM4aB2BtdFEjvMkULEqIAyY5qt9ve3Co2TUX+imuscOsXz/6SZ7NW66Q=="
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_resource_group" "eus" {
  name     = "rg-${var.name}-${random_string.this.result}-eus"
  location = local.second_location
  tags     = var.tags
}

resource "azurerm_virtual_network" "eus" {
  name                = "vnet-${var.name}-${random_string.this.result}-eus"
  address_space       = ["10.10.0.0/16"]
  location            = local.second_location
  resource_group_name = azurerm_resource_group.eus.name
  tags                = var.tags
}

resource "azurerm_subnet" "apim_eus" {
  name                 = "snet-${var.name}-${random_string.this.result}-apim"
  resource_group_name  = azurerm_resource_group.eus.name
  virtual_network_name = azurerm_virtual_network.eus.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "vm_eus" {
  name                 = "snet-${var.name}-${random_string.this.result}-vm"
  resource_group_name  = azurerm_resource_group.eus.name
  virtual_network_name = azurerm_virtual_network.eus.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_network_security_group" "apim_eus" {
  name                = "nsg-${var.name}-${random_string.this.result}-apim"
  location            = azurerm_resource_group.eus.location
  resource_group_name = azurerm_resource_group.eus.name

  security_rule {
    name                       = "allow_api_management"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow_lb"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6390"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "allow_outbound_storage"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  }

  security_rule {
    name                       = "allow_outbound_sql"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Sql"
  }

  security_rule {
    name                       = "allow_outbound_key_vault"
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  }
}

resource "azurerm_subnet_network_security_group_association" "apim_eus" {
  subnet_id                 = azurerm_subnet.apim_eus.id
  network_security_group_id = azurerm_network_security_group.apim_eus.id
}

resource "azurerm_network_interface" "jump_eus" {
  name                = "nic-${var.name}${random_string.this.result}jump"
  location            = azurerm_resource_group.eus.location
  resource_group_name = azurerm_resource_group.eus.name

  ip_configuration {
    name                          = "ifcfg-${var.name}-${random_string.this.result}-jump"
    subnet_id                     = azurerm_subnet.vm_eus.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jump_eus" {
  name                  = "vm${var.name}${random_string.this.result}jump"
  location              = azurerm_resource_group.eus.location
  resource_group_name   = azurerm_resource_group.eus.name
  size                  = "Standard_DS2_v2"
  admin_username        = "sysops"
  network_interface_ids = [azurerm_network_interface.jump_eus.id]

  admin_ssh_key {
    username   = "sysops"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIB6sSBzkec8QhrkL7i91hiqQtN7Vmfh9OYvvYXS/3myDo0E3FaWZKqFs4JFAUynze9EPlKY7yZdE1NIFZGlVP4+a9v0uSQ2y/MB/GmVQ/afQ8yYlLTEL4zYZ5a0N736lz4bXhb0eCYkMN/Tgrqo1/6b3EjS9zIQAdZD8f6uG0HBxWTaKvuDRrhlMT1c7S9rFLog2vIC/LMxHABaVPOCP38+VCoS4Iq3RCs3B/hZ8hogKHtnxwNE83CrCDH4SJ6nf9eKtj2PQXRbX9LbKcgRXwIHDzuO7CZ1VVexF6DMaRb6Xs+ADYr4QVtvZtbp2hq7ldx/cGRHPpjlkx4dpYPtX1K54EGrO45DSFYfA99VU2q0I56Af6kHUGHqJZyJh4E1/Z9ws+W43eiiidc9545zFHIZAi9xYxJ1NospfjFRn9C1smn1jw0WRmLTjxD30jfyOdZVe+BdTgxaQtNN8ZbJbTM8a5Lo3cxFa+2RIGxzvW8ZFWXOREkmwiyr/Ef2VCoXgp8zGc3REyQnj+s1kWBzQudoQ3yhZtD8nCbt5oN6s4/lFVGxO91fqR8AQqvtXUpDlTI9UhV8dFXO2c1UvmnvDGr8ZU50dyeutv9fIPXuFZKXsX+LigISzM4aB2BtdFEjvMkULEqIAyY5qt9ve3Co2TUX+imuscOsXz/6SZ7NW66Q=="
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_virtual_network_peering" "cus_to_eus" {
  name                      = "peer-${var.name}-${random_string.this.result}-to-eus"
  resource_group_name       = azurerm_resource_group.cus.name
  virtual_network_name      = azurerm_virtual_network.cus.name
  remote_virtual_network_id = azurerm_virtual_network.eus.id
}

resource "azurerm_virtual_network_peering" "eus_to_cus" {
  name                      = "peer-${var.name}-${random_string.this.result}-to-cus"
  resource_group_name       = azurerm_resource_group.eus.name
  virtual_network_name      = azurerm_virtual_network.eus.name
  remote_virtual_network_id = azurerm_virtual_network.cus.id
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = "appins-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.cus.location
  resource_group_name = azurerm_resource_group.cus.name
  application_type    = "other"
  workspace_id        = azurerm_log_analytics_workspace.this.id
  tags                = var.tags
}

module "apim" {
  source = "../../../apim"

  name_prefix          = "apim"
  location             = azurerm_resource_group.cus.location
  resource_group_name  = azurerm_resource_group.cus.name
  subnet_id            = azurerm_subnet.apim_cus.id
  logger               = local.logger
  diagnostic           = local.diagnostic
  publisher_email      = "devops@example.com"
  publisher_name       = "DevOps"
  virtual_network_type = "Internal"
  sku_name             = "Premium_1"
  additional_location  = local.additional_location
  identity             = local.identity
  tags                 = var.tags
}