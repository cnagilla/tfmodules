variable "name" {
  type        = string
  description = "Resource name"
}

variable "synapse_workspace_id" {
  type        = string
  description = "Workspace ID"
}

variable "create_mode" {
  type        = string
  description = "How to create SQL pool"
  validation {
    condition     = contains(["Default", "Recovery", "PointInTimeRestore"], var.create_mode)
    error_message = "Mode should be one of: Default, Recovery or PointInTimeRestore."
  }
}

variable "sku_name" {
  type        = string
  description = "SKU name"
  validation {
    condition     = contains(["DW100c", "DW200c", "DW300c", "DW400c", "DW500c", "DW1000c", "DW1500c", "DW2000c", "DW2500c", "DW3000c", "DW5000c", "DW6000c", "DW7500c", "DW10000c", "DW15000c", "DW30000c"], var.sku_name)
    error_message = "SKU Name should be one of: DW100c, DW200c, DW300c, DW400c, DW500c, DW1000c, DW1500c, DW2000c, DW2500c, DW3000c, DW5000c, DW6000c, DW7500c, DW10000c, DW15000c or DW30000c."
  }
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}