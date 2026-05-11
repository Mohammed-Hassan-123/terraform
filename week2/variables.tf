variable "node_name" {
  type    = string
  default = "hassan"
}

variable "ssh_key" {
  type = string
}

variable "vms" {
  type = map(object({
    vm_id    = number
    name     = string
    username = string
    password = string
    ip       = string
  }))
}

variable "pm_api_token" {
  type      = string
  sensitive = true
}

variable "pm_password" {
  type      = string
  sensitive = true
}
