provider "azurerm" {
    features {}
}

#Fetching existing subscription detials and configuration
data "azurerm_client_config" "current" {
    
}

#Fetching existing resource group in which the storage account will be created
data "azurerm_resource_group" "storage_rg"{ 
  name= var.storage_account_rg_name
}

#Fetching existing Key vault to store encryption key
data "azurerm_key_vault" "key_vault" {
  name = var.kv_name
  resource_group_name = var.kv_rg_name
}

#Creating new key vault access policy
resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id =azurerm_storage_account.storage_account.identity.0.principal_id
  key_permissions = ["get", "create", "list", "restore", "recover", "unwrapKey", "wrapKey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get"]
}

#Creating Key vault key for encryption
resource "azurerm_key_vault_key" "encrypt_key" {
  name = format("encrypt-key%s",var.storage_name)
  key_vault_id = data.azurerm_key_vault.key_vault.id
  key_type = "RSA"
  key_size = "2048"
  key_opts = ["encrypt", "decrypt", "sign", "verify", "unwrapKey", "wrapKey"]
  depends_on = [azurerm_key_vault_access_policy.storage]
}

#Creating a null resource to allow the newly created encryption key be available before it can be retrieved
resource "null_resource" "delay" {
  provisioner "local-exec" {
    #command = "SLEEP 30"
    command     = "Start-Sleep 20"
    interpreter = ["PowerShell", "-Command"]
  }
  triggers = {
    "before" = azurerm_key_vault_key.encrypt_key.id
  }
}

#Retrieve storage encryption key
resource "azurerm_storage_account_customer_managed_key" "customer_key" {
  storage_account_id = azurerm_storage_account.storage_account.id
  key_vault_id = data.azurerm_key_vault.key_vault.id
  key_name = format("encrypt-key%s",var.storage_name)
  key_version = azurerm_key_vault_key.encrypt_key.version
  depends_on = [null_resource.delay]
}

#Create storage account
resource "azurerm_storage_account" "storage_account" {
  name = var.storage_name
  resource_group_name = data.azurerm_resource_group.storage_rg.name
  location = data.azurerm_resource_group.storage_rg.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  enable_https_traffic_only = true

  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = var.environment
  }
  
}

#Fetching existing virtual network 
data "azurerm_virtual_network" "vnet_rg" {
  name                = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

#Creating network rules with respect to the storage account
resource "azurerm_storage_account_network_rules" "vnet_rule" {
  resource_group_name = data.azurerm_resource_group.storage_rg.name
  storage_account_name = var.storage_name

  default_action = length(var.allowed_subnet_ids)>0 || length(var.allowed_ips) > 0 ? "Deny" : "Allow"
  ip_rules = var.allowed_ips
  virtual_network_subnet_ids = var.allowed_subnet_ids
  bypass = ["Metrics"]
  depends_on = [azurerm_storage_account.storage_account]
}



























