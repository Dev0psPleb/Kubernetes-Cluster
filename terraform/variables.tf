# Version Control Variables

variable "build_repo" {
  description = "Version Control Repository"
  default     = "https://github.com/RalphBrynard/Kubernetes-Cluster.git"
}

variable "build_branch" {
  description = "Repository build branch"
  default     = "main"
}

# vSphere Variables
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

variable "instances" {
  description = "Number of VM instances to deploy"
  type        = number
  default     = 1
}

variable "network" {
  description = "Name of the portgroup to map the network configuration"
  default     = "app_vlan"
}

variable "portgroup" {
  description = "Mapping of network names to portgroups and portgroup configurations"
  default = {
    app_vlan = {
      cidr_prefix     = ["28"]
      default_gateway = "11.11.11.110"
      dns_server_list = ["11.11.11.113", "11.11.11.114", "11.11.11.110"]
      dns_suffix_list = ["thebrynards.com", "app.thebrynards.com"]
    },
    servers_vlan = {
      cidr_prefix     = "28"
      default_gateway = "11.11.11.126"
      dns_server_list = ["11.11.11.113", "11.11.11.114", "11.11.11.126"]
      dns_suffix_list = ["thebrynards.com"]
    },
    users_vlan = {
      cidr_prefix     = "26"
      default_gateway = "11.11.2.62"
      dns_server_list = ["11.11.2.62"]
      dns_suffix_list = ["thebrynards.com"]
    }
  }
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
variable "time_server" {
  description = "Time server to use"
  type        = string
}

# Smallstep Ansible Playbook Variables
variable "smallstep_enrollment_token" {
  description = "Smalstep SSH enrollment token"
  default     = ""
}

variable "team_id" {
  description = "Smallstep SSH Team ID"
  default     = ""
}

# GitHub Actions Runner Playbook Variables
variable "github_app_id" {
  description = "GitHub Application ID"
  default     = ""
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  default     = ""
}

variable "github_app_private_key_file" {
  description = "GitHub App Private Key file"
  default     = ""
}

variable "private_key" {
  description = "Path to the private key file for the SSH user"
  type        = string
}

# Sophos Factory Runner Variables
variable "agent_id" {
  description = "Sophos Factory Runner Agent ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "agent_key" {
  description = "Sophos Factory Runner Agent Key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "log_path" {
  description = "Log Path for Sophos Factory Runner"
  type        = string
  default     = "/var/log/runner-agent"
}

variable "log_retention" {
  description = "Default log retention period to store Sophos Factory Runner logs"
  type        = string
  default     = "30"
}

variable "workspace_path" {
  description = "Workspace for Sophos Factory Runner"
  type        = string
  default     = "/opt/runner-agent/workspace"
}

variable "log_level" {
  description = "Sophos Factory Runner log-level"
  type        = string
  default     = "info"
}

variable "log_filename_pattern" {
  description = "Sophos Factory Runner log-filename pattern"
  type        = string
  default     = "runner-agent-%DATE%.log"
}

# Ansible Join Domain Variables
variable "realm" {
  description = "Domain Realm; Kerberos Authentication."
  default     = "CONTOSO"
}

variable "realm_domain" {
  description = "Domain Name"
  default     = "CONTOSO.COM"
}

variable "realm_domain_server" {
  description = "KRB5 Admin Server"
}

variable "kerberos_user" {
  description = "KRB5 user to join the host to the domain. Preferrably a service account"
}

variable "kerberos_user_password" {
  description = "KRB5 User password"
  sensitive   = true
}

variable "realm_ad_ou" {
  description = "OU that host should populate when joined to the domain"
}

# Ansible SSSD
variable "krb5_server" {
  description = "KRB5 admin server that issues Kerberos Tickets"
}

variable "krb5_realm" {
  description = "Same as realm_domain"
}

variable "ldap_uri" {
  description = "Ldap search URI"
  default     = "ldap://domain_controller.contoso.com:389"
}

variable "ldap_default_bind_dn" {
  description = "Distinguished name of the service account that will perform the domain join."
  default     = "DN=svc_account,CN=Users,DC=contoso,DC=com"
}

variable "ldap_default_authtok" {
  description = "Password for ldap_default_bind_dn"
  sensitive   = true
}

variable "ldap_default_authtok_type" {
  description = "Default authentication token type. Default is password"
  default     = "password"
}

variable "ldap_search_base" {
  description = "LDAP Search base for user objects"
  default     = "DC=contoso,DC=com"
}

variable "ldap_user_object_class" {
  description = "LDAP attribute for identifying user objects"
  default     = "user"
}

variable "ldap_user_gecos" {
  description = "GECOS field to hold non-unix object attributes"
  default     = "name"
}

variable "ldap_group_object_class" {
  description = "LDAP attribute for identifying group objects"
  default     = "group"
}

variable "ldap_user_name" {
  description = "User name attribute"
  default     = "sAMAccountName"
}

variable "ldap_user_principal" {
  description = "User Principal Name"
  default     = "userPrincipalName"
}

variable "ldap_group_name" {
  description = "Attribute for identifying groups"
  default     = "CN"
}

variable "ldap_user_objectsid" {
  description = "User Object Security Identifier"
  default     = "objectSid"
}

variable "ldap_group_objectsid" {
  description = "Group Object Security Identifier"
  default     = "objectSid"
}

variable "ldap_user_primary_group" {
  description = "Attribute to identify user primary group"
  default     = "primaryGroupID"
}