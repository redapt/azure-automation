variable "az_subscription_id" {
  description = "Subscription id used to connect the Azure Provider"
}
variable "az_client_id" {
  description = "Client id used to connect the Azure Provider"
}
variable "az_client_secret" {
  description = "Client secret used to connect the Azure Provider"
}
variable "az_tenant_id" {
  description = "Tenant id used to connect the Azure Provider"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.az_subscription_id}"
  client_id       = "${var.az_client_id}"
  client_secret   = "${var.az_client_secret}"
  tenant_id       = "${var.az_tenant_id}"
}

# Create a resource group
resource "azurerm_resource_group" "production" {
  name     = "prod"
  location = "West US"
}

# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "network" {
  name                = "prod-net"
  address_space       = ["10.0.0.0/16"]
  location            = "West US"
  resource_group_name = "${azurerm_resource_group.production.name}"

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }
}