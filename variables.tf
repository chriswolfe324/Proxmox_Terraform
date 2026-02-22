#-----------------------------------------------------
# Proxmox Settings

variable "node_name" {
    description = "Name of Proxmox node"
    type        = string
}

#-----------------------------------------------------
# Network Settings

variable "network_interface_name" {
    description = "Name of network interface"
    type        = string
}

variable "network_interface_bridge" {
    description = "Name of bridge my infrastructure is using"
    type        = string
}

variable "default_gateway" {
    description = "IP address of default gateway"
    type        = string
}

#-----------------------------------------------------
# DNS Settings

variable "domain_name" {
    description = "Name of domain"
    type        = string
}

variable "dns_servers" {
    description = "IP address of DNS servers"
    type        = list(string)
}
#-----------------------------------------------------


