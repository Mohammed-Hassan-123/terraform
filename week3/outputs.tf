output "vm_ips" {
  value = {
    slavethree = module.slavethree.vm_ip
    slavefour  = module.slavefour.vm_ip
  }
}
