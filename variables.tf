#variables for the resource group

variable "location" {
  type        = string
  default     = "Eastus"
  description = "the default location of the resource group"
}



#variables for the vnet

variable "vnet_address_space" {
  type        = list(any)
  default     = ["10.0.0.0/16"]
  description = "the default address space for the vnet"
}


variable "pub_sub1_address" {
  type        = list(any)
  default     = ["10.0.0.0/24"]
  description = "the default address space of public subnet1"
}

variable "database_sub_address" {
  type        = list(any)
  default     = ["10.0.1.0/24"]
  description = "the default address space of the database subnet"
}

variable "database_username" {
  type        = string
  description = "the username for the database, must be declared in the .tfvars file"
}

variable "mssql_server_name" {
  type        = string
  description = "the name of the mssql server must be declared in the .tfvars file"
}

variable "mssql_database_name" {
  type        = string
  description = "the name of the mssql database must be declared in the .tfvars file"
}
