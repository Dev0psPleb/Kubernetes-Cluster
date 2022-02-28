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

variable "network" {
  description = "VMWare Network, either distributed port-group or portgroup"
  type        = string
}

variable "private_key" {
  description = "Path to the private key file for the SSH user"
  type        = string
}

variable "ram_size" {
  description = "Memory to allocate for the VM"
  type        = number
  default     = 4096
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

## Ansible Playbook Variables ##
## Chrony Vars
variable "wtd-chrony-cfg-server" {
  description = "Time server to use"
  type        = string
}

# Ansible KRB5
variable "realm-domain" {}
variable "realm-domain-server" {}
variable "kerberos-user" {}
variable "kerberos-user-password" {}
variable "realm-ad-ou" {}

# Ansible SSSD
variable "krb5-server" {}
variable "krb5-realm" {}
variable "ldap-uri" {}
variable "ldap-default-bind-dn" {}
variable "ldap-default-authtok" {}
variable "ldap-default-authtok-type" {}
variable "ldap-search-base" {}
variable "ldap-user-object-class" {}
variable "ldap-user-gecos" {}
variable "ldap-group-object-class" {}
variable "ldap-group-search-base" {}
variable "ldap-user-name" {}
variable "ldap-user-principal" {}
variable "ldap-group-name" {}
variable "ldap-objectsid" {}
variable "ldap-primary-group-id" {}