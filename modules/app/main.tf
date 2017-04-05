resource "azurerm_public_ip" "app" {
  name                         = "${var.env_name}-app-ip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_network_security_group" "app" {
  name                = "${var.env_name}_app_sg1"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "allow_http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_network_interface" "app" {
  name                = "${var.env_name}-app-ni"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${azurerm_network_security_group.app.id}"

  ip_configuration {
    name                          = "appconfiguration1"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.app.id}"
  }
}

resource "azurerm_storage_container" "app" {
  name                  = "${var.env_name}-app"
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${var.storage_account_name}"
  container_access_type = "private"
}


# creates an instance in Azure
resource "azurerm_virtual_machine" "app" {
    name                 = "${var.env_name}-app"
    vm_size              = "${var.size}"
    location             = "${var.location}"
    resource_group_name  = "${var.resource_group_name}"
    network_interface_ids = ["${azurerm_network_interface.app.id}"]

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
        vhd_uri       = "${var.storage_account_primary_blob_endpoint}${azurerm_storage_container.app.name}/app-${var.env_name}.vhd"
        caching       = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name  = "${var.env_name}-app"
        admin_username = "appadmin"
        admin_password = "Password1234!"
        custom_data = <<CUSTOM
#!/bin/bash

sudo bash -c 'cat > /etc/bootstrap.sh << "EOF"
export DEBIAN_FRONTEND=noninteractive ; \
sudo apt-get update ; \
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common ; \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - ; \
sudo apt-key fingerprint 0EBFCD88 ; \
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" ; \
sudo apt-get update ; \
sudo apt-get install -y docker-ce ; \ 
sudo service docker start ; \
sudo docker run --name app --restart unless-stopped -p 80:80 -d ${var.docker_image} ;
EOF'

sudo bash -c 'cat > /etc/redeploy.sh << "EOF"
default_image=${var.docker_image}; \
image=$${1:-$default_image}; \
sudo docker pull $1; \
sudo docker rename app old-app; \
sudo docker stop old-app; \
sudo docker run --name app --restart unless-stopped -p 80:80 -d $1; \
sudo docker rm old-app;
EOF'

CUSTOM
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "${var.env_name}"
    }


}

resource "azurerm_virtual_machine_extension" "provision_app" {
  name                 = "${var.env_name}-provision-app"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_machine_name = "${azurerm_virtual_machine.app.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.2"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo bash /etc/bootstrap.sh"
    }
SETTINGS

  tags {
    environment = "${var.env_name}"
  }
}

#resource "azurerm_virtual_machine_extension" "redeploy" {
#  name                 = "${var.env_name}-redeploy-app"
#  location             = "${var.location}"
#  resource_group_name  = "${var.resource_group_name}"
#  virtual_machine_name = "${azurerm_virtual_machine.app.name}"
#  publisher            = "Microsoft.OSTCExtensions"
#  type                 = "CustomScriptForLinux"
#  type_handler_version = "1.2"

#  settings = <<SETTINGS
#    {
#        "commandToExecute": "bash /etc/redeploy.sh ${var.docker_image}"
#    }
#SETTINGS

#  tags {
#    environment = "${var.env_name}"
#  }
#}