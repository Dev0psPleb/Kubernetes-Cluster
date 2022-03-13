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

data "template_file" "ansible_hosts" {
  template = file("../ansible/hosts.tpl")
  vars = {
    master_ip     = module.master.ip[0]
    worker1_ip    = module.worker.ip[0]
    worker2_ip    = module.worker.ip[1]
  }
}

resource "local_file" "ansible_hosts" {
  content         = data.template_file.ansible_hosts.rendered
  filename        = "../ansible/hosts"
}

module "master" {
  source          = "./modules/vsphere-vm"
  dc              = var.dc
  vmrp            = var.vmrp
  content_library = var.content_library
  vmtemp          = var.vmtemp
  instances       = 1
  cpu_number      = var.cpu_number
  ram_size        = var.ram_size
  disk_size_gb    = 16
  vmname          = "master"
  vmnameformat    = var.vmnameformat
  annotation      = "VER: ${local.build_version}\nDATE: ${local.build_date}\nSRC: ${var.build_repo} (${var.build_branch})"
  datastore       = var.datastore
  ipv4submask     = [local.cidr_prefix]
  vmgateway       = "11.11.11.110"
  network = {
    "${var.network}" = ["11.11.11.97"]
  }
  dns_server_list = var.dns_server_list
  dns_suffix_list = var.dns_suffix_list
}

module "worker" {
  source                = "./modules/vsphere-vm"
  dc                    = var.dc
  vmrp                  = var.vmrp
  content_library       = var.content_library
  vmtemp                = var.vmtemp
  instances             = 2
  cpu_number            = var.cpu_number
  ram_size              = var.ram_size
  disk_size_gb          = 16
  vmname                = "worker"
  vmnameformat          = var.vmnameformat
  annotation            = "VER: ${local.build_version}\nDATE: ${local.build_date}\nSRC: ${var.build_repo} (${var.build_branch})"
  datastore             = var.datastore
  ipv4submask           = [local.cidr_prefix]
  vmgateway             = "11.11.11.110"
  network = {
    "${var.network}" = ["11.11.11.98", "11.11.11.99"]
  }
  dns_server_list = var.dns_server_list
  dns_suffix_list = var.dns_suffix_list
}

resource "null_resource" "ansible" {
    depends_on          = [
        module.master.ip,
        module.worker.ip
      ]

    provisioner "local-exec" {
        working_dir = "../ansible"
        command     = "ansible-playbook -i hosts playbooks/kubernetes-common.yml playbooks/kubernetes-master.yml playbooks/kubernetes-worker.yml"
    }
    provisioner "local-exec" {
        working_dir = "../ansible"
        command     = "ansible-playbook -i hosts playbooks/kube-config.yml"
    }
    provisioner "local-exec" {
        command     = "export KUBECONFIG=../ansible/.kube/config"
    }
}