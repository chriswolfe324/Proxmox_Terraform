terraform {
  required_version = ">=1.14.4"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.60"
    }
  }
}

provider "proxmox" {
  insecure = true # skip TLS/SSL cert validation
}