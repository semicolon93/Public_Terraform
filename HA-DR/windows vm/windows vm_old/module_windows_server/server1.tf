
#Creating public ip for server1 server
resource "azurerm_public_ip" "server1_server_ip" {
  name                = join("-", [var.server1_server_name, "-pip"])
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  allocation_method   = "Static"
}

#Creating NIC for server1 server
resource "azurerm_network_interface" "server1_server_nic" {
  name                = join("-", [var.server1_server_name, "-nic"])
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.server1_server_subnet.id
    private_ip_address_allocation = "Dynamic" #Static
    public_ip_address_id          = azurerm_public_ip.server1_server_ip.id
  }
}

#Creating server1 server
resource "azurerm_windows_virtual_machine" "server1_server" {
  name                = var.server1_server_name
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  size                = var.server1_server_size
  admin_username      = var.server1_server_admin_username
  admin_password      = var.server1_server_admin_password
  network_interface_ids = [
    azurerm_network_interface.server1_server_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.server1_server_image_publisher
    offer     = var.server1_server_image_offer
    sku       = var.server1_server_image_sku
    version   = var.server1_server_image_version
  }
}

resource "azurerm_virtual_machine_extension" "join-domain1" {
  name                 = "join-domain"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  virtual_machine_id   = azurerm_windows_virtual_machine.server1_server.id

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain_name}",
        "OUPath": "",
        "User": "${var.active_directory_username}@${var.active_directory_domain_name}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.active_directory_password}"
    }
SETTINGS  
}