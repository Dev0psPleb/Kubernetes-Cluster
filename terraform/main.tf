provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

locals {
  vm_ip_cidr    = lookup(var.vm_network, var.network)
  cidr_prefix   = tonumber(element(split("/", local.vm_ip_cidr), 1))
  build_version = formatdate("YY.MM", timestamp())
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

module "master" {
  source                = "./modules/vsphere-vm"
  dc                    = var.dc
  vmrp                  = var.vmrp
  content_library       = var.content_library
  vmtemp                = var.vmtemp
  instances             = 1
  cpu_number            = var.cpu_number
  ram_size              = var.ram_size
  disk_size_gb          = 16
  vmname                = "master"
  vmnameformat          = var.vmnameformat
  annotation            = "VER: ${local.build_version}\nDATE: ${local.build_date}\nSRC: ${var.build_repo} (${var.build_branch})"
  datastore             = var.datastore
  ipv4submask           = [local.cidr_prefix]
  vmgateway             = "11.11.11.110"
  network = {
    "${var.network}" = ["11.11.11.97"]
  }
  dns_server_list = var.dns_server_list
  dns_suffix_list = var.dns_suffix_list
}

resource "null_resource" "master" {
  depends_on = [module.master.ip]
  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = "ansible-playbook -i hosts playbooks/users.yml"
  }
}