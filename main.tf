# you don't need all the info in firewall > options in the containers 
# until you decide to set up the firewall later

# ----------------------------Jellyfin and Samba Server---------------------------------------

resource "proxmox_virtual_environment_vm" "jellyfin_samba" {
  node_name       = "pve1"
  vm_id           = 175
  name            = "jellyfin-samba"
  keyboard_layout = "en-us"
  description     = "You also have iperf installed on this VM."

  # network info configured inside the VM

  startup {
    order = 18
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
    bridge      = "vmbr0"
    mac_address = "BC:24:11:1D:40:9C"
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
  node_name = "pve1"
  vm_id     = 184
  name      = "homeassistant"

  # network info configured inside the VM

  startup {
    order = 19
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
    bridge      = "vmbr0"
    mac_address = "BC:24:11:00:F1:97"
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
  node_name    = "pve1"
  vm_id        = 180
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
    hostname = "pi-hole"

    ip_config {
      ipv4 {
        address = "192.168.0.180/24" # include /24
        gateway = "192.168.0.1"      # do not include /24
      }
    }

    dns {
      domain  = "chriswolfe.rocks"
      servers = ["192.168.0.180"] #DNS server
    }
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:1F:1D:82"
    firewall    = true
  }

  startup {
    order = 1
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
  node_name    = "pve1"
  vm_id        = 181
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
    hostname = "book-lecture-ap"

    ip_config {
      ipv4 {
        address = "192.168.0.181/24" # include /24
        gateway = "192.168.0.1"      # do not include /24
      }
    }
    dns {
      domain  = "chriswolfe.rocks"
      servers = ["192.168.0.180"] #DNS server
    }
  }

  memory {
    dedicated = 1024
    swap      = 512
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:B5:C9:80"
    firewall    = true
  }

  startup {
    order = 4
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
  node_name    = "pve1"
  vm_id        = 182
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
    hostname = "MongoDB"

    ip_config {
      ipv4 {
        address = "192.168.0.182/24" #include the /24
        gateway = "192.168.0.1"      #Do not include /24
      }
    }
    dns {
      domain  = "chriswolfe.rocks"
      servers = ["192.168.0.180"]
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
    name        = "eth0"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:28:26:A4"
    firewall    = true
  }

  startup {
    order = 2
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
  node_name    = "pve1"
  vm_id        = 183
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
    hostname = "bookstack"

    ip_config {
      ipv4 {
        address = "192.168.0.183/24" #include /24
        gateway = "192.168.0.1"      # Do not include /24
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
    name        = "eth0"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:2C:4A:23"
    firewall    = true
  }

  startup {
    order = 5
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
  node_name    = "pve1"
  vm_id        = 186
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
    hostname = "mariadb"

    ip_config {
      ipv4 {
        address = "192.168.0.186/24" #include /24
        gateway = "192.168.0.1"      # do not include /24
      }
    }
    dns {
      domain  = "chriswolfe.rocks"
      servers = ["192.168.0.180"] #DNS server
    }
  }

  memory {
    dedicated = 512
    swap      = 0
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:F9:27:EC"
    firewall    = true
  }

  startup {
    order = 3
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
  node_name    = "pve1"
  vm_id        = 187
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
    hostname = "nginx"

    ip_config {
      ipv4 {
        address = "192.168.0.187/24" #include /24
        gateway = "192.168.0.1"      # do not inlude /24?
      }
    }
    dns {
      domain  = "chriswolfe.rocks"
      servers = ["192.168.0.180"] #DNS server
    }
  }

  memory {
    dedicated = 384
    swap      = 0
  }

  network_interface {
    name        = "eth0"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:F7:11:B0"
    firewall    = true
  }

  startup {
    order = 20
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
