resource "random_string" "this" {
  length  = var.random_string_length
  special = false
  upper   = false
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name}-${random_string.this.result}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "allow_management_inbound" {
  name                        = "allow_management_inbound"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
  name                        = "allow_misubnet_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
  name                        = "allow_health_probe_inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_tds_inbound" {
  name                        = "allow_tds_inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny_all_inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_management_outbound" {
  name                        = "allow_management_outbound"
  priority                    = 106
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
  name                        = "allow_misubnet_outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  name                        = "deny_all_outbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.this.name
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.name}-${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = "snet-${var.name}-${random_string.this.result}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]

  delegation {
    name = "sqlmi"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_route_table" "this" {
  name                          = "rt-${var.name}-${random_string.this.result}"
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  disable_bgp_route_propagation = false

  depends_on = [azurerm_subnet.this]
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = azurerm_subnet.this.id
  route_table_id = azurerm_route_table.this.id
}

module "db" {
  source = "../../mssql_managed_instance"

  name_prefix           = "sqlmi-${var.name}-${random_string.this.result}"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  subnet_id             = azurerm_subnet.this.id
  databases             = local.databases
  databases_name_prefix = "sqldb-${var.name}-${random_string.this.result}"
  tags                  = var.tags
}

# Replication to other region 
resource "random_string" "dr" {
  length  = var.random_string_length
  special = false
  upper   = false
}


resource "azurerm_resource_group" "dr" {
  name     = "rg-${var.name}-${random_string.dr.result}-${var.dr_location}"
  location = var.dr_location
  tags     = var.tags
}

resource "azurerm_virtual_network" "dr" {
  name                = "vnet-${var.name}-${random_string.dr.result}"
  location            = azurerm_resource_group.dr.location
  resource_group_name = azurerm_resource_group.dr.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "dr" {
  name                 = "snet-${var.name}-${random_string.dr.result}"
  resource_group_name  = azurerm_resource_group.dr.name
  virtual_network_name = azurerm_virtual_network.dr.name
  address_prefixes     = ["10.20.0.0/24"]

  delegation {
    name = "sqlmi"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}


resource "azurerm_network_security_group" "dr" {
  name                = "nsg-${var.name}-${random_string.dr.result}"
  location            = azurerm_resource_group.dr.location
  resource_group_name = azurerm_resource_group.dr.name
}

resource "azurerm_network_security_rule" "dr_allow_management_inbound" {
  name                        = "allow_management_inbound"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_allow_misubnet_inbound" {
  name                        = "allow_misubnet_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.20.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_allow_health_probe_inbound" {
  name                        = "allow_health_probe_inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_allow_tds_inbound" {
  name                        = "allow_tds_inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_deny_all_inbound" {
  name                        = "deny_all_inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_allow_management_outbound" {
  name                        = "allow_management_outbound"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_allow_misubnet_outbound" {
  name                        = "allow_misubnet_outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.20.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "dr_deny_all_outbound" {
  name                        = "deny_all_outbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}


resource "azurerm_subnet_network_security_group_association" "dr" {
  subnet_id                 = azurerm_subnet.dr.id
  network_security_group_id = azurerm_network_security_group.dr.id
}

resource "azurerm_route_table" "dr" {
  name                          = "rt-${var.name}-${random_string.dr.result}"
  location                      = azurerm_resource_group.dr.location
  resource_group_name           = azurerm_resource_group.dr.name
  disable_bgp_route_propagation = false

  depends_on = [azurerm_subnet.dr]
}

resource "azurerm_subnet_route_table_association" "dr" {
  subnet_id      = azurerm_subnet.dr.id
  route_table_id = azurerm_route_table.dr.id
}


## Replication releated NSG to be added
resource "azurerm_network_security_rule" "allow_prod_dr_inbound" {
  name                        = "allow_prod_dr_inbound"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["5022", "11000-11999"]
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "10.20.0.0/24"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

resource "azurerm_network_security_rule" "allow_dr_prod_outbound" {
  name                        = "allow_dr_prod_inbound"
  priority                    = 1010
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["5022", "11000-11999"]
  source_address_prefix       = "10.20.0.0/24"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = azurerm_resource_group.dr.name
  network_security_group_name = azurerm_network_security_group.dr.name
}

module "dr_db" {
  source = "../../mssql_managed_instance"

  name_prefix           = "sqlmi-${var.name}-${random_string.this.result}-${var.dr_location}"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  subnet_id             = azurerm_subnet.this.id
  databases             = local.databases
  databases_name_prefix = "sqldb-${var.name}-${random_string.this.result}"
  dns_zone_partner_id   = module.db.id
  tags                  = var.tags
}

# Actual module for failover group

module "sqlmi_failover_group" {
  source = "../../mssql_failover_group"

  name_prefix                 = "sqlmifailovergroup-${var.name}-${random_string.this.result}-${var.location}-${var.dr_location}"
  location                    = "eastus2"
  managed_instance_id         = module.db.id
  partner_managed_instance_id = module.dr_db.id
  failover_mode               = "Automatic"
  grace_period                = 60
}

