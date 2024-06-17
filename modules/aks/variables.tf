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

variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
  default     = "myVNet"
}

variable "subnet_name" {
  description = "The name of the Subnet"
  type        = string
  default     = "mySubnet"
}

variable "address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "The address prefix for the Subnet"
  type        = string
  default     = "10.0.1.0/24"
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
