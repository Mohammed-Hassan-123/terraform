terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.4"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://192.168.100.9:8006/"
  api_token = "terraform@pve!terraform-token=5961539d-c0a8-40e3-95c4-3c163424f2bd"
  insecure  = true

  ssh {
    agent    = false
    username = "root"
    password = "Dragon+Power+008"
  }
}
