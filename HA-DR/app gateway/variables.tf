variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_rg" {
  type =string
}

variable "managed_identity_name" {
  type = string
}
/*
variable "keyvault_id" {
  type =string
}

variable "appgw_kv_sslcertificate_name" {
  type = string
}

variable "appgw_kv_trustedrootcertificate_name" {
  type = string
}
*/
variable "appgw_name" {
  type = string
}

variable "appgw_sku_name" {
  type = string
} 

variable "appgw_sku_tier" {
  type = string
}
/*
variable "appgw_capacity" {
  type = number
}
*/
variable "appgw_frontend_port" {
  type = string
}

variable "appgw_frontend_private_ip_address" {
  type = string
}

variable "appgw_backend_address_pool_name" {
  type = string
}

variable "appgw_backend_ip_addresses" {
  type = list
}

variable "hostnames" {

}

variable "appgw_tls_ciphers" {
  type = list
  default = ["TLS_RSA_WITH_AES_256_CBC_SHA256", "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384", "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256", "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256", "TLS_DHE_RSA_WITH_AES_128_GCM_SHA256", "TLS_RSA_WITH_AES_128_GCM_SHA256", "TLS_RSA_WITH_AES_128_CBC_SHA256", "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA", "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384", "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"]
}

variable "appgw_log_analytics_name" {
  type = string
}

variable "appgw_log_analytics_sku" {
  type = string 
  default = "PerGB2018"
}

variable "appgw_frontend_subnet_name" {
  type = string
}

variable "appgw_frontend_subnet_address_prefixes" {
  type = list
}

variable "log_analytics_workspace_id" {
    type = string
}

































