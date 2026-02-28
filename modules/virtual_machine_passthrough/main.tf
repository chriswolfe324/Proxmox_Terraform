resource "proxmox_virtual_environment_vm" "vm" {
  node_name = var.node_name
  vm_id     = var.vm_id
  name      = var.name

  description     = var.description
  keyboard_layout = var.keyboard_layout

  on_boot       = var.on_boot
  bios          = var.bios
  machine       = var.machine
  acpi          = var.acpi
  tablet_device = var.tablet_device
  hotplug       = var.hotplug
  protection    = var.protection

  scsi_hardware = var.scsi_hardware
  boot_order    = var.boot_order

  dynamic "startup" {
    for_each = var.startup == null ? [] : [var.startup]
    content {
      order = startup.value.order
    }
  }

  dynamic "agent" {
    for_each = var.agent == null ? [] : [var.agent]
    content {
      enabled = agent.value.enabled
      type    = try(agent.value.type, null)
    }
  }

  dynamic "operating_system" {
    for_each = var.operating_system == null ? [] : [var.operating_system]
    content {
      type = operating_system.value.type
    }
  }

  cpu {
    sockets = var.cpu.sockets
    cores   = var.cpu.cores
    type    = try(var.cpu.type, null)
  }

  memory {
    dedicated = var.memory.dedicated
    floating  = try(var.memory.floating, null)
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      datastore_id      = try(disk.value.datastore_id, null)
      interface         = disk.value.interface
      size              = try(disk.value.size, null)
      discard           = try(disk.value.discard, null)
      iothread          = try(disk.value.iothread, null)
      path_in_datastore = try(disk.value.path_in_datastore, null)
      backup            = try(disk.value.backup, null)
    }
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk == null ? [] : [var.efi_disk]
    content {
      datastore_id = efi_disk.value.datastore_id
      type         = efi_disk.value.type
    }
  }

  dynamic "cdrom" {
    for_each = var.cdrom == null ? [] : [var.cdrom]
    content {
      interface = cdrom.value.interface
      file_id   = cdrom.value.file_id
    }
  }

  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge      = network_device.value.bridge
      mac_address = try(network_device.value.mac_address, null)
      model       = try(network_device.value.model, null)
      firewall    = try(network_device.value.firewall, null)
    }
  }

  dynamic "smbios" {
    for_each = var.smbios == null ? [] : [var.smbios]
    content {
      uuid = smbios.value.uuid
    }
  }

    lifecycle {
    ignore_changes = [
      disk[1],
      disk[2],
    ]
  }
}