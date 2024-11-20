resource "azurerm_kubernetes_cluster_node_pool" "this" {
  name                  = var.name
  kubernetes_cluster_id = var.kubernetes_cluster_id
  vm_size               = var.vm_size
  node_count            = var.node_count
  mode                  = var.mode
  max_pods              = var.max_pods
  vnet_subnet_id        = var.vnet_subnet_id
  enable_node_public_ip = var.enable_node_public_ip
  zones                 = var.zones
  os_disk_size_gb       = var.os_disk_size_gb
  node_labels           = var.node_labels
  enable_auto_scaling   = var.enable_auto_scaling
  max_count             = var.max_count
  min_count             = var.min_count
  tags                  = var.tags
}
