resource "azurerm_mysql_server" "blogdb" {
  name                = var.blogdb_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "GP_Gen5_2"

  
  storage_mb = 5120
  version    = "8.0"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  

  administrator_login          = var.blogdb_login
  administrator_login_password = var.blogdb_password
  #version                      = var.blogdb_version
  ssl_enforcement_enabled           = false
}

resource "azurerm_mysql_database" "blogdb" {
  name                = "blogdb"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_server.blogdb.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "wordpress" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_server.blogdb.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      ="255.255.255.255"
}

