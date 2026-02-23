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


#-----------------------------------------------------
# Jellyfin-Samba  

variable "jellyfin_samba_vm_id" {
  description = "VM_ID of jellyfin-samba VM"
  type        = number
}

variable "jellyfin_samba_hostname" {
  description = "Hostname of jellyfin-samba VM"
  type        = string
}

variable "jellyfin_samba_mac_address" {
  description = "MAC address of jellyfin-samba VM"
  type        = string
}

variable "jellyfin_samba_startup_order" {
  description = "Startup order of jellyfin-samba VM"
  type        = number
}

#-----------------------------------------------------
# Home Assistant    

variable "home_assistant_vm_id" {
  description = "VM_ID of home_assistant VM"
  type        = number
}

variable "home_assistant_hostname" {
  description = "Hostname of home_assistant VM"
  type        = string
}

variable "home_assistant_mac_address" {
  description = "MAC address of home_assistant VM"
  type        = string
}

variable "home_assistant_startup_order" {
  description = "Startup order of home_assistant VM"
  type        = number
}

#-----------------------------------------------------
# Pi-hole

variable "pihole_vm_id" {
  description = "VM_ID of pihole container"
  type        = number
}

variable "pihole_hostname" {
  description = "Hostname of pihole container"
  type        = string
}

variable "pihole_ip_address" {
  description = "IP address of pihole container"
  type        = string
}

variable "pihole_mac_address" {
  description = "MAC address of pihole container"
  type        = string
}

variable "pihole_startup_order" {
  description = "Startup order of pihole container"
  type        = number
}

#-----------------------------------------------------
# Book-Lecture-Database   

variable "book_lecture_vm_id" {
  description = "VM_ID of book-lecture app container"
  type        = number
}

variable "book_lecture_hostname" {
  description = "Hostname of book-lecture app container"
  type        = string
}

variable "book_lecture_ip_address" {
  description = "IP address of book-lecture app container"
  type        = string
}

variable "book_lecture_mac_address" {
  description = "MAC address of book-lecture app container"
  type        = string
}

variable "book_lecture_startup_order" {
  description = "Startup order of book-lecture app container"
  type        = number
}

#-----------------------------------------------------
# MongoDB  

variable "mongodb_vm_id" {
  description = "VM_ID of mongodb container"
  type        = number
}

variable "mongodb_hostname" {
  description = "Hostname of mongodb container"
  type        = string
}

variable "mongodb_ip_address" {
  description = "IP address of mongodb container"
  type        = string
}

variable "mongodb_mac_address" {
  description = "MAC address of mongodb container"
  type        = string
}

variable "mongodb_startup_order" {
  description = "Startup order of mongodb container"
  type        = number
}

#-----------------------------------------------------
# Bookstack 

variable "bookstack_vm_id" {
  description = "VM_ID of bookstack container"
  type        = number
}

variable "bookstack_hostname" {
  description = "Hostname of bookstack container"
  type        = string
}

variable "bookstack_ip_address" {
  description = "IP address of bookstack container"
  type        = string
}

variable "bookstack_mac_address" {
  description = "MAC address of bookstack container"
  type        = string
}

variable "bookstack_startup_order" {
  description = "Startup order of bookstack container"
  type        = number
}

#-----------------------------------------------------
# MariaDB 

variable "mariadb_vm_id" {
  description = "VM_ID of mariadb container"
  type        = number
}

variable "mariadb_hostname" {
  description = "Hostname of mariadb container"
  type        = string
}

variable "mariadb_ip_address" {
  description = "IP address of mariadb container"
  type        = string
}

variable "mariadb_mac_address" {
  description = "MAC address of mariadb container"
  type        = string
}

variable "mariadb_startup_order" {
  description = "Startup order of mariadb container"
  type        = number
}

#-----------------------------------------------------
# nginx

variable "nginx_vm_id" {
  description = "VM_ID of nginx container"
  type        = number
}

variable "nginx_hostname" {
  description = "Hostname of nginx container"
  type        = string
}

variable "nginx_ip_address" {
  description = "IP address of nginx container"
  type        = string
}

variable "nginx_mac_address" {
  description = "MAC address of nginx container"
  type        = string
}

variable "nginx_startup_order" {
  description = "Startup order of nginx container"
  type        = number
}