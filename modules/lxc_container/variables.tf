variable "node_name" { type = string }
variable "vm_id" { type = string }
variable "hostname" { type = string }

variable "ipv4_address" { type = string }
variable "gateway" { type = string }

variable "network_interface_name" { type = string }
variable "network_interface_bridge" { type = string }
variable "mac_address" { type = string }

variable "startup_order" { type = number }

variable "disk_datastore_id" { type = string }
variable "disk_size" { type = number }

variable "memory_dedicated" { type = number }
variable "memory_swap" { type = number }

#Book-lecture uses DNS. Bookstack does not
variable "enable_dns" { type = bool }

variable "dns_domain" {
  type    = string
  default = ""
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

