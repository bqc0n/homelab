terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {}

locals {
  ssh_public_keys = <<-EOT
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr
  EOT

  ubuntu_server_iso="local:iso/ubuntu-24.04.1-live-server-amd64.iso"
}

resource "proxmox_lxc" "core" {
  target_node  = "pve02"
  hostname     = "core"
  ostemplate   = "local:vztmpl/ubuntu-24.04-2_amd64.tar.zst"
  password     = "mou.mai"
  start = true
  unprivileged = true

  memory = 4096

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "16G"
  }

  nameserver = "127.0.0.1"

  ssh_public_keys = "${local.ssh_public_keys}"

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.2/24"
    gw = "192.168.1.1"
  }
}

resource "proxmox_vm_qemu" "docker_runner" {
  target_node               = "pve02"
  name                      = "docker-holder"
  vm_state = "running"

  cores = 8
  memory = 16384
  os_type = "ubuntu"
  nameserver = "192.168.1.2"
  sshkeys = "${local.ssh_public_keys}"

  ipconfig0="gw=192.168.1.1,ip=dhcp"

  disks {
    ide {
      ide2 {
        cdrom {
          iso = "${local.ubuntu_server_iso}"
        }       
      }
    }
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size = "64G"
        }
      }
    }
  }

  network {
    model = "virtio"
    bridge    = "vmbr0"
  }
}
