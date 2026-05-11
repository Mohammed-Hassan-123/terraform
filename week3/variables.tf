variable "node_name" {
  type    = string
  default = "hassan"
}

variable "ssh_key" {
  type = string
}

variable "gateway" {
  type    = string
  default = "192.168.100.1"
}

variable "pm_api_token" {
  type      = string
  sensitive = true
}

variable "pm_password" {
  type      = string
  sensitive = true
}
