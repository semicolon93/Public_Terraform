/*
#Creating public ip for server
resource "azurerm_public_ip" "db_pip" {
  count = length(var.db_server)
  name                = join("-", [var.db_server[count.index].name, "-pip"])
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  allocation_method   = "Static"
}*/

#Creating NIC for server
resource "azurerm_network_interface" "db_nic" {
  count = length(var.db_server)
  name                = join("-", [var.db_server[count.index].name, "-nic"])
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.db_server_subnet[count.index].id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.db_server[count.index].private_ip_address
    #public_ip_address_id          = azurerm_public_ip.db_pip[count.index].id
  }
}

#Creating server
resource "azurerm_windows_virtual_machine" "db_server" {
  count = length(var.db_server)
  name                = var.db_server[count.index].name
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  size                = var.db_server[count.index].size
  admin_username      = var.db_server[count.index].admin_username
  admin_password      = var.db_server[count.index].admin_password
  network_interface_ids = [
    azurerm_network_interface.db_nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.db_server[count.index].image_publisher
    offer     = var.db_server[count.index].image_offer
    sku       = var.db_server[count.index].image_sku
    version   = var.db_server[count.index].image_version
  }
}

resource "azurerm_managed_disk" "db_disk1" {
  count = length(var.db_server)
  name                 = "${var.db_server[count.index].name}-disk1"
  location             = data.azurerm_resource_group.ws_rg.location
  resource_group_name  = data.azurerm_resource_group.ws_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.db_server[count.index].data_disk_size[0]
}

resource "azurerm_virtual_machine_data_disk_attachment" "db_disk_attachment1" {
  count = length(var.db_server)
  managed_disk_id    = azurerm_managed_disk.db_disk1[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.db_server[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}
/*
resource "azurerm_managed_disk" "db_disk2" {
  count = length(var.db_server)
  name                 = "${var.db_server[count.index].name}-disk2"
  location             = data.azurerm_resource_group.ws_rg.location
  resource_group_name  = data.azurerm_resource_group.ws_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.db_server[count.index].data_disk_size[1]
}

resource "azurerm_virtual_machine_data_disk_attachment" "db_disk_attachment2" {
  count = length(var.db_server)
  managed_disk_id    = azurerm_managed_disk.db_disk2[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.db_server[count.index].id
  lun                = "20"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "db_disk3" {
  count = length(var.db_server)
  name                 = "${var.db_server[count.index].name}-disk3"
  location             = data.azurerm_resource_group.ws_rg.location
  resource_group_name  = data.azurerm_resource_group.ws_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.db_server[count.index].data_disk_size[2]
}

resource "azurerm_virtual_machine_data_disk_attachment" "db_disk_attachment3" {
  count = length(var.db_server)
  managed_disk_id    = azurerm_managed_disk.db_disk3[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.db_server[count.index].id
  lun                = "30"
  caching            = "ReadWrite"
}
*/
resource "azurerm_virtual_machine_extension" "db_feature" {
  count = length(var.web_server)
  name                 = "add-windows-feature"
  virtual_machine_id   = azurerm_windows_virtual_machine.db_server[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./db_feature.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://storageaccounttf01.blob.core.windows.net/script/db_feature.ps1"
        ]
    }
  SETTINGS
}
