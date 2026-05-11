output "vm_ips" {
  value = {
    slavethree = module.slavethree.vm_ip
    slavefour  = module.slavefour.vm_ip
  }
}

output "inventory_file" {
  value = local_file.ansible_inventory.filename
}

output "vm_password" {
  value     = var.vm_password
  sensitive = true
}
