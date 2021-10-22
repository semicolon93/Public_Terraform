variable "environment" {
    type = string
}

variable "storage_account_rg_name" {
    type = string
}

variable "kv_name" {
    type = string
}

variable "kv_rg_name" {
    type = string
}

variable "storage_name" {
    type = string
}

variable "account_tier" {
    type = string
}

variable "account_replication_type" {
    type = string
}

variable "vnet_name" {
    type = string
}

variable "vnet_rg_name" {
    type = string
}

variable "allowed_subnet_ids" {
    type = list
    default = []
}

variable "allowed_ips" {
    type = list
    default =[]
}


