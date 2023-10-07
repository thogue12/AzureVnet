# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {

  }
}

# Create a resource group

resource "azurerm_resource_group" "resource_group" {
  name     = "tims_rg"
  location = "Eastus"
}

# Create a virtual network within the resource group

resource "azurerm_virtual_network" "vnet" {
  name                = "tims_vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = ["10.0.0.0/16"]
}

#Network Security Group and Rule(s)

resource "azurerm_network_security_group" "network_sg" {
  name                = "tims_nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "allow_rdp_from_anywhere"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "pub-subnet1" {
  name                 = "public-sub"
  virtual_network_name = "tims_vnet"
  resource_group_name  = "tims_rg"
  address_prefixes     = ["10.0.0.0/24"]
}

output "subnet_id" {
  value = resource.azurerm_subnet.pub-subnet1.id
}