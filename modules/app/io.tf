
########### Azure Instance 'demo-node' resource variables #############
#### the variables in this file are passed in at environment level ####

# instance variables
variable size          { default = "Basic_A1" }
variable location      { default = "West US" }
variable env_name {}
variable resource_group_name {}
variable subnet_id {}
variable docker_image { default = "redapt/redapt-demo" }
variable storage_account_primary_blob_endpoint {}
variable storage_account_name {}

output "public_ip" { value = "${ azurerm_public_ip.app.ip_address }" }