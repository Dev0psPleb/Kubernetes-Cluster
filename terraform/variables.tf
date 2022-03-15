variable "build_repo" {
  description = "Version Control Repository"
  default     = "https://github.com/RalphBrynard/Kubernetes-Cluster.git"
}

variable "build_branch" {
  description = "Repository build branch"
  default     = "main"
}

variable "cluster" {
  description = "vSphere Datacenter compute cluster"
  type        = string
}

variable "content_library" {
  description = "vSphere Content Library name"
  type        = string
}

variable "cpu_number" {
  description = "Number of vCPU's to provision"
  type        = number
  default     = 2
}

variable "datastore" {
  description = "vSphere Datastore to store the VM disk"
  type        = string
  default     = ""
}

variable "datastore_cluster" {
  description = "vSphere Datastore cluster to store the VM disk"
  type        = string
  default     = ""
}

variable "dc" {
  description = "vSphere Datacenter name"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of the disk for deployed OVF templates"
  type        = number
  default     = null
}

variable "dns_server_list" {
  description = "List of DNS Servers to use"
  type        = list(any)
}

variable "dns_suffix_list" {
  description = "List of DNS Suffix to apply to the VM"
  type        = list(string)
}

variable "instances" {
  description = "Number of VM instances to deploy"
  type        = number
  default     = 1
}

variable "private_key" {
  description = "Path to the private key file for the SSH user"
  type        = string
}

variable "ram_size" {
  description = "Memory to allocate for the VM"
  type        = number
  default     = 2048
}

variable "ssh_user" {
  description = "User to use for SSH connection"
  type        = string
}

variable "vm_network" {
  description = "Map of VLAN subnet CIDR's"
  type        = map(any)
  default = {
    app_vlan = "11.11.11.110/28"
  }
}

variable "vapp_name" {
  description = "vApp name"
  type        = string
}

variable "vmname" {
  description = "Name of the VM"
  type        = string
}

variable "vmnameformat" {
  description = "Name format to apply to each provisioned instance"
  type        = string
  default     = "%02d"
}

variable "vmrp" {
  description = "vSphere Resource Pool name"
  type        = string
}

variable "vmtemp" {
  description = "Name of the template to use for the virtual machine"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere user password"
  type        = string
}

variable "vsphere_server" {
  description = "vSphere Server hostname or IP address"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere Username"
  type        = string
}

variable "smallstep_enrollment_token" {}
variable "team_id" {}
## Ansible Playbook Variables ##
## Chrony Vars
variable "time_server" {
  description = "Time server to use"
  type        = string
}

variable "network" {
  default = "app_vlan"
}

variable "portgroup" {
  default = {
    app_vlan = {
      cidr_prefix     = ["28"]
      default_gateway = "11.11.11.110"
      dns_server_list = ["11.11.11.113", "11.11.11.114", "11.11.11.110"]
      dns_suffix_list = ["app.thebrynards.com", "thebrynards.com"]
    },
    servers_vlan = {
      cidr_prefix     = "28"
      default_gateway = "11.11.11.126"
      dns_server_list = ["11.11.11.113", "11.11.11.114", "11.11.11.126"]
      dns_suffix_list = ["thebrynards.com"]
    }
  }
}

# Ansible KRB5
variable "realm" {}
variable "realm_domain" {}
variable "realm_domain_server" {}
variable "kerberos_user" {}
variable "kerberos_user_password" {}
variable "realm_ad_ou" {}

# Ansible SSSD
variable "krb5_server" {}
variable "krb5_realm" {}
variable "ldap_uri" {}
variable "ldap_default_bind_dn" {}
variable "ldap_default_authtok" {}
variable "ldap_default_authtok_type" {}
variable "ldap_search_base" {}
variable "ldap_user_object_class" {}
variable "ldap_user_gecos" {}
variable "ldap_group_object_class" {}
variable "ldap_user_name" {}
variable "ldap_user_principal" {}
variable "ldap_group_name" {}
variable "ldap_user_objectsid" {}
variable "ldap_group_objectsid" {}
variable "ldap_user_primary_group" {}