variable "ws_rg_name" {
  type = string
}

variable "vnet_rg" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "server_subnet_name" {
  type = string
}

variable "server_subnet_cidr" {
  type = list
}

variable "lbprivate_ip_address" {
  type = string
}

variable "server1_name" {
  type = string
}

variable "server2_name" {
  type = string
}

variable "server_size" {
  type = string
}

variable "server_admin_username" {
  type = string
}

variable "server_admin_password" {
  type = string
}

variable "active_directory_domain_name" {
  type = string
}

variable "active_directory_username" {
  type = string
}

variable "active_directory_password" {
  type = string
}

/*
variable "server_image_publisher" {
  type = string
}

variable "server_image_offer" {
  type = string
}

variable "server_image_sku" {
  type = string
}

variable "server_image_version" {
  type = string
}
*/