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
  location = var.location
}

# Create a virtual network within the resource group

resource "azurerm_virtual_network" "vnet" {
  name                = "tims_vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  address_space       = var.vnet_address_space
}

#Network Security Group and Rule(s)

resource "azurerm_network_security_group" "network_sg" {
  name                = "tims_nsg"
  location            = var.location
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

#I was constantly running into a problem on lines 58 and 59 and it was becuase when naming the resource group and virtual network
#I was adding the ""  marks with name and they did not need them here. once I fixed that it worked perfectly
resource "azurerm_subnet" "pub_subnet1" {
  name                 = "public_sub"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.resource_group.name
  address_prefixes     = var.pub_sub1_address
}

output "subnet_id" {
  value = resource.azurerm_subnet.pub_subnet1.id
}