variable "node_name" {
  type    = string
  default = "hassan"
}

variable "gateway" {
  type    = string
  default = "192.168.100.1"
}

variable "ssh_key" {
  type      = string
  sensitive = true
}

variable "pm_api_token" {
  type      = string
  sensitive = true
}

variable "pm_password" {
  type      = string
  sensitive = true
}

variable "vm_password" {
  type      = string
  sensitive = true
}

variable "pm_ssh_username" {
  type      = string
  sensitive = true
}

variable "pm_ssh_password" {
  type      = string
  sensitive = true
}
