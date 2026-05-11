resource "proxmox_virtual_environment_vm" "vms" {
  for_each        = var.vms
  node_name       = var.node_name
  vm_id           = each.value.vm_id
  name            = each.value.name
  stop_on_destroy = true

  clone {
    vm_id = 9000
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

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "192.168.100.1"
      }
    }
    user_account {
      username = each.value.username
      password = each.value.password
      keys     = [var.ssh_key]
    }
  }
}
