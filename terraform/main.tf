provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

locals {
  vm_ip_cidr  = lookup(var.vm_network, var.network)
  cidr_prefix = tonumber(element(split("/", local.vm_ip_cidr), 1))
}

module "vm" {
  source          = "./modules/vsphere-vm"
  dc              = var.dc
  vmrp            = var.vmrp
  content_library = var.content_library
  vmtemp          = var.vmtemp
  instances       = var.instances
  cpu_number      = var.cpu_number
  ram_size        = var.ram_size
  disk_size_gb    = 16
  vmname          = var.vmname
  vmnameformat    = var.vmnameformat
  datastore       = var.datastore
  ipv4submask     = [local.cidr_prefix]
  network = {
    "${var.network}" = ["", "", ""]
  }
  dns_server_list = var.dns_server_list
  dns_suffix_list = var.dns_suffix_list
}