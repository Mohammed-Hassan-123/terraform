module "slavethree" {
  source    = "./modules/vm"
  node_name = var.node_name
  vm_id     = 103
  name      = "slavethree"
  username  = "slavethree"
  password  = var.vm_password
  ip        = "192.168.100.18/24"
  gateway   = var.gateway
  ssh_key   = var.ssh_key
}

module "slavefour" {
  source    = "./modules/vm"
  node_name = var.node_name
  vm_id     = 104
  name      = "slavefour"
  username  = "slavefour"
  password  = var.vm_password
  ip        = "192.168.100.19/24"
  gateway   = var.gateway
  ssh_key   = var.ssh_key
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    slavethree_ip = module.slavethree.vm_ip
    slavefour_ip  = module.slavefour.vm_ip
  })
  filename   = "${path.module}/inventory.ini"
  depends_on = [module.slavethree, module.slavefour]
}

resource "proxmox_virtual_environment_vm" "slaveone" {
  node_name       = var.node_name
  vm_id           = 101
  name            = "slaveone"
  stop_on_destroy = true

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [scsi_hardware, cpu, disk, network_device, operating_system, vga, initialization]
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_vm" "slavetwo" {
  node_name       = var.node_name
  vm_id           = 102
  name            = "slavetwo"
  stop_on_destroy = true

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [scsi_hardware, cpu, disk, network_device, operating_system, vga, initialization]
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 1024
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }
}
