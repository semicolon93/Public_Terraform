variable "main_resource_group" {
}

variable "main_resource_group_location" {
  default = "East US"
}

variable "main_vnet_name" {
}

variable "main_vnet_space" {
  default = "10.66.0.0/16"
}

variable "aks_subnet_address" {
  default = ["10.66.0.0/24"]
}

variable "client_id" {
}

variable "client_secret_name" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}

variable "aks_name" {
}

variable "aks_dns_prefix" {
}

/*
variable "aks_linux_admin" { }

variable "aks_linux_ssh_key" { }*/

variable "sql_db_login" {
}

variable "sqldb_password_name" {
}

variable "sql_server_name" {
}

variable "blogdb_sku" {
  type = map(string)
  default = {
    name     = "B_Gen4_1"
    capacity = "1"
    tier     = "Basic"
    family   = "Gen4"
  }
}

variable "blogdb_storage" {
  type = map(string)
  default = {
    size             = "5120"
    backup_retention = "7"
  }
}

variable "blogdb_version" {
  default = "5.7"
}

variable "aks_agent_size" {
  default = "Standard_DS2_v2"
}

variable "aks_agent_pool" {
  default = "agentpool"
}

variable "aks_agent_count" {
  default = "3"
}

variable "aks_agent_count_max" {
  default = "4"
}

variable "autoscaler_version" {
  default = "v1.13.0"
}

variable "aks_version" {
  default = "1.17.11"
}

variable "wordpress_Username" {}
variable "wordpress_Password_name" {}
variable "wordpress_Email" {}
variable "wordpress_BlogName" {}
variable "kv_name" {}
variable "kv_rg" {}
