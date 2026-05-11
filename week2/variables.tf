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
