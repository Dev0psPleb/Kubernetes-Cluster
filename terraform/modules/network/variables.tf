variable "portgroup" {
  default = {
    app_vlan = {
      cidr_prefix     = "28"
      default_gateway = "11.11.11.110"
      dns_server_list = ["11.11.11.113", "11.11.11.114", "11.11.11.110"]
      dns_suffix_list = ["app.thebrynards.com", "thebrynards.com"]
    },
    servers_vlan = {
      cidr_prefix     = "28"
      default_gateway = "1.1.1.1"
      dns_server_list = ["8.8.8.8", "8.8.4.4"]
      dns_suffix_list = ["development.com"]
    }
  }
}

variable "vm_network" {
  type    = string
  default = "servers_vlan"
}