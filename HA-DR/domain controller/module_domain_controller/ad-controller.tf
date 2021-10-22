locals {
  virtual_machine_fqdn = join(".", [var.dc_name, var.active_directory_domain_name])
  auto_logon_data      = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
  first_logon_data     = file("${path.module}/files/FirstLogonCommands.xml")
  custom_data_params   = "Param($RemoteHostName = \"${local.virtual_machine_fqdn}\", $ComputerName = \"${var.dc_name}\")"
  custom_data          = base64encode(join(" ", [local.custom_data_params, file("${path.module}/files/winrm.ps1")]))

  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain_name} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  exit_code_hack       = "exit 0"
  powershell_command   = "${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"

}

resource "azurerm_network_interface" "dc_nic" {
  name                = join("-", [var.dc_name, "-nic-primary"])
  location            = data.azurerm_resource_group.dc_rg.location
  resource_group_name = data.azurerm_resource_group.dc_rg.name
  ip_configuration {
    name                          = "primary"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.dc_private_ip
    subnet_id                     = azurerm_subnet.dc.id
  }
}

resource "azurerm_windows_virtual_machine" "domain_controller" {
  name                = var.dc_name
  resource_group_name = data.azurerm_resource_group.dc_rg.name
  location            = data.azurerm_resource_group.dc_rg.location
  size                = var.dc_size 
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  custom_data         = local.custom_data

  network_interface_ids = [
    azurerm_network_interface.dc_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.dc_image_publisher 
    offer     = var.dc_image_offer 
    sku       = var.dc_image_sku 
    version   = var.dc_image_version 
  }

  additional_unattend_content {
    content = local.auto_logon_data
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_data
    setting = "FirstLogonCommands"
  }
}

resource "azurerm_virtual_machine_extension" "create-ad-forest" {
  name                 = "create-active-directory-forest"
  virtual_machine_id   = azurerm_windows_virtual_machine.domain_controller.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
  {
    "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
  }
SETTINGS
}