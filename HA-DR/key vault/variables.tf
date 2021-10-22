variable "environment"{
    type = string
}

variable "kv_rg_name"{
    type = string
}

variable "kv_name"{
    type = string
}

variable "sku" {
  type        = string
  default     = "standard"
}

variable "enabled_for_deployment" {
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = true
}

variable "network_acls" {
  type = string
}