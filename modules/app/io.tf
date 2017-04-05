
########### Azure Instance 'demo-node' resource variables #############
#### the variables in this file are passed in at environment level ####

# instance variables
variable size          { default = "Basic_A1" }
variable location      { default = "West US" }
variable env_name {}
variable resource_group_name {}
variable storage_account {}
variable storage_container {}
variable network_interface_ids { type = "list" }