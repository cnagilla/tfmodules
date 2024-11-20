module "nic" {
  for_each = var.nic
  source   = "../nic"

  name                 = try(each.value["name"], "nic-${var.name}-${each.key}")
  location             = var.location
  resource_group_name  = var.resource_group_name
  ip_configuration     = each.value["ip_configuration"]
  enable_ip_forwarding = try(each.value["enable_ip_forwarding"], false)
  tags                 = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  count = var.os_family == "windows" ? 1 : 0

  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = values(module.nic)[*].id
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  custom_data           = var.custom_data

  source_image_reference {
    publisher = var.image["publisher"]
    offer     = var.image["offer"]
    sku       = var.image["sku"]
    version   = var.image["version"]
  }

  os_disk {
    name                 = try(var.disk["name"], var.name)
    storage_account_type = var.disk["storage_account_type"]
    caching              = var.disk["caching"]
    disk_size_gb         = try(var.disk["disk_size_gb"], null)
  }

  lifecycle {
    ignore_changes = [
      custom_data
    ]
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  count = var.os_family == "linux" ? 1 : 0

  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = values(module.nic)[*].id
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  custom_data                     = var.custom_data

  source_image_reference {
    publisher = var.image["publisher"]
    offer     = var.image["offer"]
    sku       = var.image["sku"]
    version   = var.image["version"]
  }

  os_disk {
    name                 = try(var.disk["name"], "disk-${var.name}")
    storage_account_type = var.disk["storage_account_type"]
    caching              = var.disk["caching"]
    disk_size_gb         = try(var.disk["disk_size_gb"], null)
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }

  lifecycle {
    ignore_changes = [
      custom_data
    ]
  }

  tags = var.tags
}