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



# before running terraform plan, run:
# terraform init to initialize the provider
# terraform import to tell TF about existing VM/CT
# then run terraform plan