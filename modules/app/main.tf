# creates an instance in Azure
resource "azurerm_virtual_machine" "node" {
    name                 = "${var.env_name}-node"
    vm_size              = "${var.size}"
    location             = "${var.location}"
    resource_group_name  = "${var.resource_group_name}"
    network_interface_ids = ["${var.network_interface_ids}"]

    # FOR DEMONSTRATION PURPOSES
    delete_os_disk_on_termination = "true"

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "14.04.2-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name          = "app-${var.env_name}"
        vhd_uri       = "${var.storage_account}${var.storage_container}/app-${var.env_name}.vhd"
        caching       = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name  = "${var.env_name}-node"
        admin_username = "nodeadmin"
        admin_password = "Password1234!"
        custom_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
EOF
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "${var.env_name}"
    }


}

resource "azurerm_virtual_machine_extension" "node" {
  name                 = "${var.env_name}-run-app"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${azurerm_virtual_machine.node.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.2"

  settings = <<SETTINGS
    {
        "commandToExecute": "bash -c 'sudo docker rm old-app; sudo docker rename app old-app; sudo docker kill old-app; sudo docker run --name app -p 80:80 -d redapt/redapt-demo'"
    }
SETTINGS

  tags {
    environment = "${var.env_name}"
  }
}