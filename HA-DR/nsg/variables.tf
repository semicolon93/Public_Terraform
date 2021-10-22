variable "nsg_rules_file" {
    type = string
}

variable "nsg_name" {
    type = string
}

#Azure location
variable "location" {
    type = string
}

variable "vnet_rg_name" {
    type = string
}

variable "vnet_name" {
type = string
}

variable "subnet_name" {
     type = string
}

variable "subnet_cidr" {
type = list
}
/*
variable "dependency" {
}*/

