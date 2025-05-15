terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc9"
    }
  }
}

resource "proxmox_lxc" "ubuntu_lxc" {
  target_node = ""
  onboot = true
  ostemplate      = "local:vztmpl/ubuntu-24.04-2_amd64.tar.zst"
  start           = true
  unprivileged    = true

  rootfs {
    storage = "local-lvm"
    size    = ""
  }
}