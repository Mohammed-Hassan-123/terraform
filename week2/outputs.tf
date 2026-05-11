output "vm_ip_addresses" {
  value = {
    for k, vm in proxmox_virtual_environment_vm.vms :
    k => vm.ipv4_addresses[1][0]
  }
}
