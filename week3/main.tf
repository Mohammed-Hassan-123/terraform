module "slavethree" {
  source   = "./modules/vm"
  node_name = var.node_name
  vm_id    = 103
  name     = "slavethree"
  username = "slavethree"
  password = "12345678"
  ip       = "192.168.100.18/24"
  gateway  = var.gateway
  ssh_key  = var.ssh_key
}

module "slavefour" {
  source    = "./modules/vm"
  node_name = var.node_name
  vm_id     = 104
  name      = "slavefour"
  username  = "slavefour"
  password  = "12345678"
  ip        = "192.168.100.19/24"
  gateway   = var.gateway
  ssh_key   = var.ssh_key
}
