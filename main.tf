# you don't need all the info in firewall > options in the containers 
# until you decide to set up the firewall later

# ----------------------------Jellyfin and Samba Server---------------------------------------

resource "proxmox_virtual_environment_vm" "jellyfin_samba" {
  node_name       = var.node_name
  vm_id           = var.jellyfin_samba_vm_id
  name            = var.jellyfin_samba_hostname
  keyboard_layout = "en-us"
  description     = "You also have iperf installed on this VM."

  # network info configured inside the VM

  startup {
    order = var.jellyfin_samba_startup_order
  }

  agent {
    enabled = true
    type    = "virtio"
  }

  operating_system {
    type = "l26"
  }

  cpu {
    sockets = 1
    cores   = 2
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2560
    floating  = 1024
  }

  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0", "ide2", "net0"]

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 30
    discard      = "on"
    iothread     = true
  }

  disk {
    interface         = "scsi1"
    path_in_datastore = "/dev/disk/by-id/ata-TOSHIBA_HDWD130_584M35XAS"
    backup            = false
  }

  disk {
    interface         = "scsi2"
    path_in_datastore = "/dev/disk/by-id/ata-TOSHIBA_HDWD130_584M33WAS"
    backup            = false
  }

  cdrom {
    interface = "ide2"
    file_id   = "none"
  }

  network_device {
    bridge      = var.network_interface_bridge
    mac_address = var.jellyfin_samba_mac_address
    model       = "virtio"
    firewall    = true
  }

  on_boot       = true
  bios          = "seabios"
  machine       = "pc"
  acpi          = true
  tablet_device = true
  hotplug       = "disk,network,usb"
  protection    = false

  smbios {
    uuid = "3de28b5a-aef3-4856-9aee-6627dd298b32"
  }

  lifecycle {
    ignore_changes = [
      disk[1], # ignoring my passed-through drive
      disk[2], # ignoring my passed-through drive
    ]
  }
}

# ---------------------------Home Assistant Server----------------------------------------

resource "proxmox_virtual_environment_vm" "home_assistant" {
  node_name = var.node_name
  vm_id     = var.home_assistant_vm_id
  name      = var.home_assistant_hostname

  # network info configured inside the VM

  startup {
    order = var.home_assistant_startup_order
  }

  agent {
    enabled = false
  }

  operating_system {
    type = "l26"
  }

  cpu {
    sockets = 1
    cores   = 2
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 3072
  }

  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0"]

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 32
    discard      = "on"
    iothread     = true
  }

  efi_disk {
    datastore_id = "local-lvm"
    type         = "4m"
  }

  cdrom {
    interface = "ide2"
    file_id   = "none"
  }

  network_device {
    bridge      = var.network_interface_bridge
    mac_address = var.home_assistant_mac_address
    model       = "virtio"
    firewall    = true
  }

  on_boot       = true
  bios          = "ovmf"
  machine       = "q35"
  acpi          = true
  tablet_device = true
  hotplug       = "disk,network,usb"
  protection    = false

  smbios {
    uuid = "8db76472-6fd0-45dd-a950-6e963b283f7c"
  }
}

# ----------------------------Pi-Hole Container---------------------------------------

resource "proxmox_virtual_environment_container" "pihole" {
  node_name    = var.node_name
  vm_id        = var.pihole_vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "VM-Disks"
    size         = 6
  }

  initialization {
    hostname = var.pihole_hostname

    ip_config {
      ipv4 {
        address = var.pihole_ip_address
        gateway = var.default_gateway
      }
    }

    dns {
      domain  = var.domain_name
      servers = var.dns_servers #DNS server
    }
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.pihole_mac_address
    firewall    = true
  }

  startup {
    order = var.pihole_startup_order
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      start_on_boot,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
    ]
  }

}

# ------------------------------Book-lecture-app Container-------------------------------------

resource "proxmox_virtual_environment_container" "book-lecture-app" {
  node_name    = var.node_name
  vm_id        = var.book_lecture_vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "VM-Disks"
    size         = 12
  }

  initialization {
    hostname = var.book_lecture_hostname

    ip_config {
      ipv4 {
        address = var.book_lecture_ip_address
        gateway = var.default_gateway
      }
    }
    dns {
      domain  = var.domain_name
      servers = var.dns_servers #DNS server
    }
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.book_lecture_mac_address
    firewall    = true
  }

  startup {
    order = var.book_lecture_startup_order
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      start_on_boot,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
    ]
  }

}
# ------------------------------MongoDB Container-------------------------------------

resource "proxmox_virtual_environment_container" "mongoDB" {
  node_name    = var.node_name
  vm_id        = var.mongodb_vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "VM-Disks"
    size         = 20
  }

  initialization {
    hostname = var.mongodb_hostname

    ip_config {
      ipv4 {
        address = var.mongodb_ip_address
        gateway = var.default_gateway
      }
    }
    dns {
      domain  = var.domain_name
      servers = var.dns_servers
    }
  }

  cpu {
    architecture = "amd64"
    cores        = 2
    units        = 1024
  }

  memory {
    dedicated = 2048
    swap      = 512
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.mongodb_mac_address
    firewall    = true
  }

  startup {
    order = var.mongodb_startup_order
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      start_on_boot,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
    ]
  }
}

# ----------------------------Bookstack Container---------------------------------------

resource "proxmox_virtual_environment_container" "bookstack" {
  node_name    = var.node_name
  vm_id        = var.bookstack_vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "VM-Disks"
    size         = 20
  }

  initialization {
    hostname = var.bookstack_hostname

    ip_config {
      ipv4 {
        address = var.bookstack_ip_address
        gateway = var.default_gateway
      }
    }
    #domain and DNS servers are set to use the host value
    # so I omitted the DNS block
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.bookstack_mac_address
    firewall    = true
  }

  startup {
    order = var.bookstack_startup_order
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      start_on_boot,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
    ]
  }
}

# -----------------------------MariaDB--------------------------------------

resource "proxmox_virtual_environment_container" "mariadb" {
  node_name    = var.node_name
  vm_id        = var.mariadb_vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "VM-Disks"
    size         = 10
  }

  initialization {
    hostname = var.mariadb_hostname

    ip_config {
      ipv4 {
        address = var.mariadb_ip_address
        gateway = var.default_gateway
      }
    }
    dns {
      domain  = var.domain_name
      servers = var.dns_servers #DNS server
    }
  }

  memory {
    dedicated = 512
    swap      = 0
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.mariadb_mac_address
    firewall    = true
  }

  startup {
    order = var.mariadb_startup_order
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      start_on_boot,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
    ]
  }
}

# ----------------------------nginx Container---------------------------------------

resource "proxmox_virtual_environment_container" "nginx" {
  node_name    = var.node_name
  vm_id        = var.nginx_vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = "VM-Disks"
    size         = 5
  }

  initialization {
    hostname = var.nginx_hostname

    ip_config {
      ipv4 {
        address = var.nginx_ip_address
        gateway = var.default_gateway
      }
    }
    dns {
      domain  = var.domain_name
      servers = var.dns_servers #DNS server
    }
  }

  memory {
    dedicated = 384
    swap      = 0
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.nginx_mac_address
    firewall    = true
  }

  startup {
    order = var.nginx_startup_order
  }

  lifecycle {
    ignore_changes = [
      operating_system,
      start_on_boot,
      timeout_clone,
      timeout_create,
      timeout_delete,
      timeout_update,
    ]
  }
}