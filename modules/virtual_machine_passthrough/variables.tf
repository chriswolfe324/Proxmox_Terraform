variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "keyboard_layout" {
  type    = string
  default = null
}

variable "on_boot" {
  type    = bool
  default = true
}

variable "bios" {
  type    = string
  default = "seabios"
}

variable "machine" {
  type    = string
  default = "pc"
}

variable "acpi" {
  type    = bool
  default = true
}

variable "tablet_device" {
  type    = bool
  default = true
}

variable "hotplug" {
  type    = string
  default = null
}

variable "protection" {
  type    = bool
  default = false
}

variable "scsi_hardware" {
  type    = string
  default = "virtio-scsi-single"
}

variable "boot_order" {
  type    = list(string)
  default = null
}

variable "startup" {
  type = object({
    order = number
  })
  default = null
}

variable "agent" {
  type = object({
    enabled = bool
    type    = optional(string)
  })
  default = null
}

variable "operating_system" {
  type = object({
    type = string
  })
  default = null
}

variable "cpu" {
  type = object({
    sockets = number
    cores   = number
    type    = optional(string)
  })
}

variable "memory" {
  type = object({
    dedicated = number
    floating  = optional(number)
  })
}

variable "disks" {
  type = list(object({
    datastore_id      = optional(string)
    interface         = string
    size              = optional(number)
    discard           = optional(string)
    iothread          = optional(bool)
    path_in_datastore = optional(string)
    backup            = optional(bool)
  }))
  default = []
}

variable "efi_disk" {
  type = object({
    datastore_id = string
    type         = string
  })
  default = null
}

variable "cdrom" {
  type = object({
    interface = string
    file_id   = string
  })
  default = null
}

variable "network_devices" {
  type = list(object({
    bridge      = string
    mac_address = optional(string)
    model       = optional(string)
    firewall    = optional(bool)
  }))
  default = []
}

variable "smbios" {
  type = object({
    uuid = string
  })
  default = null
}

variable "ignore_changes" {
  type    = list(any)
  default = []
}