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
variable "az_state_access_key" {
  description = "Azure Storage Account access key used for managing tfstate."
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.az_subscription_id}"
  client_id       = "${var.az_client_id}"
  client_secret   = "${var.az_client_secret}"
  tenant_id       = "${var.az_tenant_id}"
}

# setup remote state data source
data "terraform_remote_state" "redapt" {
  backend = "azure"
  config {
    storage_account_name = "redapt"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
    access_key           = "${var.az_state_access_key}"
  }
}