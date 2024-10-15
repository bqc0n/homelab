terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.10:8006/api2/json"
}

resource "proxmox_lxc" "core" {
  target_node  = "pve02"
  hostname     = "core"
  ostemplate   = "local:vztmpl/ubuntu-24.04-2_amd64.tar.zst"
  password     = "bqmt09"
  unprivileged = true

  memory = 4096

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "16G"
  }

  nameserver = "192.168.1.1"

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.2/24"
    gw = "192.168.1.1"
  }
}
