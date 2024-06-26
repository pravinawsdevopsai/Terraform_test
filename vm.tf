resource "azurerm_linux_virtual_machine" "example" {
  #count = 2

  name                = "mylinuxvm"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  #admin_password      = "Redhat@12345"
  network_interface_ids = [
    azurerm_network_interface.myvmnic.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/ssh-keys/terrafrom-azure.pub")
  }

  os_disk {

    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  ##to execute the shell script terraform has an meta argument called as custom_data
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
}

