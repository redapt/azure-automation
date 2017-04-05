variable "arm_subscription_id" {
  description = "Subscription id used to connect the Azure Provider"
}
variable "arm_client_id" {
  description = "Client id used to connect the Azure Provider"
}
variable "arm_client_secret" {
  description = "Client secret used to connect the Azure Provider"
}
variable "arm_tenant_id" {
  description = "Tenant id used to connect the Azure Provider"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.arm_subscription_id}"
  client_id       = "${var.arm_client_id}"
  client_secret   = "${var.arm_client_secret}"
  tenant_id       = "${var.arm_tenant_id}"
}
