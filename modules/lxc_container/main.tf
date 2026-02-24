resource "proxmox_virtual_environment_container" "container" {
  node_name    = var.node_name
  vm_id        = var.vm_id
  unprivileged = true
  started      = true
  protection   = false

  console {
    enabled   = true
    tty_count = 2
    type      = "tty"
  }

  disk {
    datastore_id = var.disk_datastore_id
    size         = var.disk_size
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.gateway
      }
    }

    dynamic "dns" {
      for_each = var.enable_dns ? [1] : []
      content {
        domain  = var.dns_domain
        servers = var.dns_servers
      }
    }
  }

  dynamic "cpu" {
    for_each = var.enable_cpu ? [1] : []
    content {
      architecture = var.cpu_architecture
      cores        = var.cpu_cores
      units        = var.cpu_units
    }
  }

  memory {
    dedicated = var.memory_dedicated
    swap      = var.memory_swap
  }

  network_interface {
    name        = var.network_interface_name
    bridge      = var.network_interface_bridge
    mac_address = var.mac_address
    firewall    = true
  }

  startup {
    order = var.startup_order
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