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
