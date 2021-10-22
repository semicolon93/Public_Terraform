/*
#Creating public ip for app server1
resource "azurerm_public_ip" "server1_ip" {
  name                = join("-", [var.server1_name, "-pip"])
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  allocation_method   = "Static"
  sku                          = "Standard"
}*/

#Creating NIC for app server1
resource "azurerm_network_interface" "server1_nic" {
  name                = join("-", [var.server1_name, "-nic"])
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  ip_configuration {
    name                          = join("-", [var.server1_name, "-ipconfig"])
    subnet_id                     = azurerm_subnet.server_subnet.id
    private_ip_address_allocation = "Dynamic"
    
    #public_ip_address_id          = azurerm_public_ip.server1_ip.id
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "server1_assoc" {
  network_interface_id    = azurerm_network_interface.server1_nic.id
  ip_configuration_name   = join("-", [var.server1_name, "-ipconfig"])
  backend_address_pool_id = azurerm_lb_backend_address_pool.loadbalancer_backend.id
  depends_on              = [azurerm_lb_rule.SQLAlwaysOnEndPointListener,azurerm_lb_probe.loadbalancer_probe]
}

#Creating app server1
resource "azurerm_windows_virtual_machine" "server1" {
  name                = var.server1_name
  location            = data.azurerm_resource_group.ws_rg.location
  resource_group_name = data.azurerm_resource_group.ws_rg.name
  availability_set_id = azurerm_availability_set.sqlavailabilityset.id
  size                = var.server_size
  admin_username      = var.server_admin_username
  admin_password      = var.server_admin_password
  network_interface_ids = [
    azurerm_network_interface.server1_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2016SP2-WS2016"
    sku       = "Enterprise"
    version   = "latest"

    /*publisher = var.server1_image_publisher
    offer     = var.server1_image_offer
    sku       = var.server1_image_sku
    version   = var.server1_image_version*/
  }
}

resource "azurerm_managed_disk" "disk11" {
  name                 = "${var.server1_name}-disk1"
  location             = data.azurerm_resource_group.ws_rg.location
  resource_group_name  = data.azurerm_resource_group.ws_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 500
}

resource "azurerm_virtual_machine_data_disk_attachment" "example11" {
  managed_disk_id    = azurerm_managed_disk.disk11.id
  virtual_machine_id = azurerm_windows_virtual_machine.server1.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "disk12" {
  name                 = "${var.server1_name}-disk2"
  location             = data.azurerm_resource_group.ws_rg.location
  resource_group_name  = data.azurerm_resource_group.ws_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 500
}

resource "azurerm_virtual_machine_data_disk_attachment" "example12" {
  managed_disk_id    = azurerm_managed_disk.disk12.id
  virtual_machine_id = azurerm_windows_virtual_machine.server1.id
  lun                = "20"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "join-domain1" {
  name                 = "join-domain"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  virtual_machine_id   = azurerm_windows_virtual_machine.server1.id

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

resource "azurerm_virtual_machine_extension" "wsfc1" {
  name                 = "create-cluster"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  virtual_machine_id   = azurerm_windows_virtual_machine.server1.id

  settings = <<SETTINGS
    { 
      "commandToExecute": "powershell Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools -IncludeAllSubFeature"
    } 
SETTINGS

  depends_on = [azurerm_virtual_machine_extension.join-domain1]
}