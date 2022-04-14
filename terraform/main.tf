provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

locals {
  portgroup       = lookup(var.portgroup, var.network)
  ipv4submask     = local.portgroup.cidr_prefix
  vmgateway       = local.portgroup.default_gateway
  dns_server_list = local.portgroup.dns_server_list
  dns_suffix_list = local.portgroup.dns_suffix_list
  domain          = local.portgroup.dns_suffix_list[0]
  build_version   = formatdate("YY.MM", timestamp())
  build_date      = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

data "template_file" "ansible_cfg" {
  template = file("../ansible/ansible.cfg.tpl")
  vars = {
    private_key_file = var.private_key
    ansible_user     = var.ssh_user
  }
}

data "template_file" "ansible_hosts" {
  template = file("../ansible/hosts.tpl")
  vars = {
    ansible_user = var.ssh_user
    master_ip    = module.master.ip[0]
    worker1_ip   = module.worker.ip[0]
    worker2_ip   = module.worker.ip[1]
  }
}

data "template_file" "join_domain_vars" {
  template = file("../ansible/vars/join_domain_vars.yaml.tpl")
  vars = {
    realm                     = var.realm
    realm_domain              = var.realm_domain
    realm_domain_server       = var.realm_domain_server
    kerberos_user             = var.kerberos_user
    kerberos_user_password    = var.kerberos_user_password
    realm_ad_ou               = var.realm_ad_ou
    sssd_testuser             = var.kerberos_user
    krb5_server               = var.krb5_server
    krb5_realm                = var.krb5_realm
    ldap_uri                  = var.ldap_uri
    ldap_default_bind_dn      = var.ldap_default_bind_dn
    ldap_default_authtok      = var.ldap_default_authtok
    ldap_default_authtok_type = var.ldap_default_authtok_type
    ldap_search_base          = var.ldap_search_base
    ldap_user_search_base     = var.ldap_search_base
    ldap_user_object_class    = var.ldap_user_object_class
    ldap_user_gecos           = var.ldap_user_gecos
    ldap_group_search_base    = var.ldap_search_base
    ldap_group_object_class   = var.ldap_group_object_class
    ldap_user_name            = var.ldap_user_name
    ldap_user_principal       = var.ldap_user_principal
    ldap_group_name           = var.ldap_group_name
    ldap_user_objectsid       = var.ldap_user_objectsid
    ldap_group_objectsid      = var.ldap_group_objectsid
    ldap_user_primary_group   = var.ldap_user_primary_group
    time_server               = var.time_server
  }
}

data "template_file" "github_actions_vars" {
  template = file("../ansible/vars/github_actions_vars.yaml.tpl")
  vars = {
    APP_ID                = var.github_app_id
    INSTALLATION_ID       = var.github_app_installation_id
    PRIVATE_KEY_FILE_PATH = var.github_app_private_key_file
  }
}

data "template_file" "smallstep_vars" {
  template = file("../ansible/vars/smallstep_vars.yaml.tpl")
  vars = {
    smallstep_enrollment_token = var.smallstep_enrollment_token
    team_id                    = var.team_id
  }
}

resource "local_file" "ansible_cfg" {
  content  = data.template_file.ansible_cfg.rendered
  filename = "../ansible/ansible.cfg"
}

resource "local_file" "join_domain_vars" {
  content  = data.template_file.join_domain_vars.rendered
  filename = "../ansible/vars/join_domain_vars.yaml"
}

resource "local_file" "smallstep_vars" {
  content  = data.template_file.smallstep_vars.rendered
  filename = "../ansible/vars/smallstep_vars.yaml"
}

resource "local_file" "github_actions_vars" {
  content  = data.template_file.github_actions_vars.rendered
  filename = "../ansible/vars/github_actions_vars.yaml"
}

resource "local_file" "ansible_hosts" {
  content  = data.template_file.ansible_hosts.rendered
  filename = "../ansible/hosts"
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
  vmname          = "k8s-master"
  domain          = local.domain
  vmnameformat    = var.vmnameformat
  annotation      = "VER: ${local.build_version}\nDATE: ${local.build_date}\nSRC: ${var.build_repo} (${var.build_branch})"
  datastore       = var.datastore
  ipv4submask     = local.ipv4submask
  vmgateway       = local.vmgateway
  network = {
    "${var.network}" = [""]
  }
  dns_server_list = local.dns_server_list
  dns_suffix_list = local.dns_suffix_list
}

module "worker" {
  source          = "./modules/vsphere-vm"
  depends_on      = [module.master]
  dc              = var.dc
  vmrp            = var.vmrp
  content_library = var.content_library
  vmtemp          = var.vmtemp
  instances       = 2
  cpu_number      = var.cpu_number
  ram_size        = var.ram_size
  disk_size_gb    = 16
  vmname          = "k8s-worker"
  domain          = local.domain
  vmnameformat    = var.vmnameformat
  annotation      = "VER: ${local.build_version}\nDATE: ${local.build_date}\nSRC: ${var.build_repo} (${var.build_branch})"
  datastore       = var.datastore
  ipv4submask     = local.ipv4submask
  vmgateway       = local.vmgateway
  network = {
    "${var.network}" = ["", ""]
  }
  dns_server_list = local.dns_server_list
  dns_suffix_list = local.dns_suffix_list
}

resource "null_resource" "kubernetes_common" {
  depends_on = [
    module.master.ip,
    module.worker.ip
  ]

  provisioner "local-exec" {
    working_dir = "../ansible"
    command     = <<-EOT
      ansible-playbook -i hosts playbooks/kubernetes-common.yaml \
                                playbooks/kubernetes-master.yaml \
                                playbooks/kubernetes-worker.yaml 
    EOT
  }
}