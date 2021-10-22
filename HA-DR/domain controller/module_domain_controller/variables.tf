/*variable "prefix" {
  type = string
}
*/
variable "location" {
  type = string
}

variable "dc_rg" {
  type = string
}

variable "dm_rg" {
  type = string
}

variable "vnet_rg" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "dc_subnet" {
  type = list
}

variable "dm_subnet" {
  type = list
}

variable "active_directory_domain_name" {
  type = string
}

variable "active_directory_netbios_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "active_directory_username" {
  type = string
}

variable "active_directory_password" {
  type = string
}

variable "dc_name" {
  type = string 
}

variable "dc_private_ip" {
  type = string
}

variable "dc_size" {
    type = string
}

variable "dc_image_publisher" {
    type = string
}

variable "dc_image_offer" {
    type = string
}

variable "dc_image_sku" {
    type = string
}

variable "dc_image_version" {
    type = string
}

variable "dm_name" {
  type = string 
}

variable "dm_size" {
    type = string
}

variable "dm_image_publisher" {
    type = string
}

variable "dm_image_offer" {
    type = string
}

variable "dm_image_sku" {
    type = string
}

variable "dm_image_version" {
    type = string
}

