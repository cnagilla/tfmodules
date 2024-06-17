variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "East US"
}

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "myAKSCluster"
}

variable "node_count" {
  description = "The number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "node_vm_size" {
  description = "The size of the AKS cluster nodes"
  type        = string
  default     = "Standard_DS2_v2"
}
