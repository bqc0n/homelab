locals {
  ssh_public_keys = <<-EOT
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr
  EOT
}

resource "proxmox_lxc" "file_server" {
  vmid            = 302
  target_node     = "pve01"
  hostname        = "FileServer"
  ostemplate      = "local:vztmpl/ubuntu-24.04-2_amd64.tar.zst"
  password        = data.sops_file.secrets.data["password.myself"]
  ssh_public_keys = local.ssh_public_keys
  unprivileged    = true
  nameserver      = "192.168.1.2"

  onboot = true
  start  = true

  cores  = 4
  memory = 8192

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.5/24"
    gw     = "192.168.1.1"
  }
}

