resource "proxmox_virtual_environment_vm" "slavethree" {
  node_name       = "hassan"
  vm_id           = 103
  name            = "slavethree"
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
        address = "dhcp"
      }
    }
    user_account {
      username = "slavethree"
      password = "12345678"
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMN6nr4wwzsQbopwrjD0hTAoHVlI35/PEMtg41T7zgb4 ansible-master"]
    }
  }
}

resource "proxmox_virtual_environment_vm" "slavefour" {
  node_name       = "hassan"
  vm_id           = 104
  name            = "slavefour"
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
        address = "dhcp"
      }
    }
    user_account {
      username = "slavefour"
      password = "12345678"
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMN6nr4wwzsQbopwrjD0hTAoHVlI35/PEMtg41T7zgb4 ansible-master"]
    }
  }
}
