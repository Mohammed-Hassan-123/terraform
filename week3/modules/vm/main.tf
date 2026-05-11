terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.4"
    }
  }
}
resource "proxmox_virtual_environment_vm" "vm" {
  node_name	  = var.node_name
  vm_id		  = var.vm_id
  name		  = var.name
  stop_on_destroy = true

  clone {
    vm_id = var.template
  }
  
  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
     bridge = "vmbr0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }
    user_account {
      username = var.username
      password = var.password
      keys     = [var.ssh_key]
    }
  }
}
