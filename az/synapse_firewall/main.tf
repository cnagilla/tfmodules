resource "azurerm_synapse_firewall_rule" "this" {
  for_each = var.rules

  name                 = each.value["name"]
  start_ip_address     = each.value["start_ip_address"]
  end_ip_address       = each.value["end_ip_address"]
  synapse_workspace_id = var.synapse_workspace_id
}