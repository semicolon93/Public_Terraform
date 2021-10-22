/*
locals {
  virtual_machine_name = join("-", [var.prefix, "client"])
  wait_for_domain_command = "while (!(Test-Connection -TargetName ${var.active_directory_domain_name} -Count 1 -Quiet) -and ($retryCount++ -le 360)) { Start-Sleep 10 }"
}*/

resource "azurerm_public_ip" "static" {
  name                = join("-", [var.dm_name, "-pip"])
  location            = data.azurerm_resource_group.dm_rg.location
  resource_group_name = data.azurerm_resource_group.dm_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "dm_nic" {
  name                = join("-", [var.dm_name, "-nic-primary"]) 
  location            = data.azurerm_resource_group.dm_rg.location
  resource_group_name = data.azurerm_resource_group.dm_rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.dm.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.static.id
  }
}

resource "azurerm_windows_virtual_machine" "domain_member" {
  name                     = var.dm_name
  resource_group_name      = data.azurerm_resource_group.dm_rg.name
  location                 = data.azurerm_resource_group.dm_rg.location
  size                     = var.dm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  provision_vm_agent       = true
  enable_automatic_updates = true

  network_interface_ids = [
    azurerm_network_interface.dm_nic.id,
  ]

  source_image_reference {
    publisher = var.dm_image_publisher 
    offer     = var.dm_image_offer 
    sku       = var.dm_image_sku 
    version   = var.dm_image_version 
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

// Waits for up to 1 hour for the Domain to become available. Will return an error 1 if unsuccessful preventing the member attempting to join.

/*
resource "azurerm_virtual_machine_extension" "suspend_till_dc_creation" {
  name                 = "TestConnectionDomain"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  virtual_machine_id   = azurerm_windows_virtual_machine.domain_member.id
  settings             = <<SETTINGS
  {
    "commandToExecute": "powershell.exe -Command \"while (!(Test-Connection -ComputerName ${var.active_directory_domain_name} -Count 1 -Quiet) -and ($retryCount++ -le 360)) { Start-Sleep 10 } \""
  }
SETTINGS
}
*/
resource "azurerm_virtual_machine_extension" "join-domain" {
  name                 = azurerm_windows_virtual_machine.domain_member.name
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  virtual_machine_id   = azurerm_windows_virtual_machine.domain_member.id

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

  #depends_on = [azurerm_virtual_machine_extension.suspend_till_dc_creation]
}
