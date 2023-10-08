#variables for the resource group

variable "location" {
  type        = string
  default     = "Eastus"
  description = "the default location of the resource group"
}



#variables for the vnet

variable "vnet_address_space" {
  type        = list
  default     = ["10.0.0.0/16"]
  description = "the default address space for the vnet"
}


variable "pub_sub1_address" {
  type        = list
  default     = ["10.0.0.0/24"]
  description = "the default address space of public subnet1"
}