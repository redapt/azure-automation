variable "env_name" {
  description = "The name of your environment."
}
variable "location" {
  description = "Location of the environment's resource group."
  default     = "West US"
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.env_name}"
  location = "${var.location}"
}

# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "main" {
  name                = "${var.env_name}-net"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

}

resource "azurerm_subnet" "main" {
  name                 = "${var.env_name}-sub"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "main" {
  name                         = "${var.env_name}-main-1"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.env_name}_app_sg1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  security_rule {
    name                       = "allow_all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.env_name}-ni"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"

  ip_configuration {
    name                          = "mainconfiguration1"
    subnet_id                     = "${azurerm_subnet.main.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.main.id}"
  }
}

resource "azurerm_storage_account" "main" {
  name                = "redapt${var.env_name}sa"
  resource_group_name = "${azurerm_resource_group.main.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "${var.env_name}-vhds"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  storage_account_name  = "${azurerm_storage_account.main.name}"
  container_access_type = "private"
}

#module "app" {
#  source = "./modules/app"
#  resource_group_name = "${azurerm_resource_group.main.name}"
#  env_name     = "${var.env_name}"
#  storage_account = "${azurerm_storage_account.main.primary_blob_endpoint}"
#  storage_container = "${azurerm_storage_container.main.name}"

#  size         = "Basic_A1"
#  location     = "${var.location}"
#  network_interface_ids = ["${azurerm_network_interface.main.id}"]
#}