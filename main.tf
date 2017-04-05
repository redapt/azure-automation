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

resource "azurerm_storage_account" "main" {
  name                = "redapt${var.env_name}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"

  tags {
    environment = "${var.env_name}"
  }
}

module "app" {
  source = "./modules/app"
  resource_group_name = "${azurerm_resource_group.main.name}"
  env_name     = "${var.env_name}"
  subnet_id    = "${azurerm_subnet.main.id}"

  storage_account_name = "${azurerm_storage_account.main.name}"
  storage_account_primary_blob_endpoint = "${azurerm_storage_account.main.primary_blob_endpoint}"

  size         = "Basic_A1"
  location     = "${var.location}"

  docker_image = "redapt/redapt-demo"
}

output "app_public_ip" { value = "${ module.app.public_ip }" }