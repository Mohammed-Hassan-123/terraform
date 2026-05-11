variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "ip" {
  type = string
}

variable "gateway" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "cores" {
  type = number
  default = 1
}

variable "memory" {
  type = number
  default = 1024
}

variable "disk_size" {
  type = number
  default = 20
}

variable "template" {
  type = number
  default = 9000
}
