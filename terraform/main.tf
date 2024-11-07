terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
    sops = {
      source = "carlpett/sops"
      version = "1.1.1"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.1.10:8006/api2/json"
  pm_api_token_id = data.sops_file.secrets.data["proxmox.user_id"]
  pm_api_token_secret = data.sops_file.secrets.data["proxmox.token"]
}

locals {
  ssh_public_keys = <<-EOT
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr
  EOT
}

resource "proxmox_lxc" "dnsmasq" {
  vmid         = 201
  target_node  = "pve02"
  hostname     = "dnsmasq"
  ostemplate   = "local:vztmpl/ubuntu-24.04-2_amd64.tar.zst"
  password     = "mou.mai"
  start        = true
  unprivileged = true

  memory = 4096

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "16G"
  }

  ssh_public_keys = local.ssh_public_keys

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.1.2/24"
    ip6 = data.sops_file.secrets.data["machines.primary_dns.ipv6"]
    gw     = "192.168.1.1"
    gw6 = "fe80::9203:25ff:fe35:3eef"
  }
}

resource "proxmox_vm_qemu" "docker_runner" {
  vmid        = 202
  target_node = "pve02"
  name        = "docker-runner"
  vm_state    = "running"

  clone   = "ubuntu-24.04-template"
  os_type = "cloud-init"
  boot    = "order=scsi0"

  cores      = 8
  memory     = 16384
  nameserver = "192.168.1.2"

  ipconfig0 = "ip=192.168.1.3/24,gw=192.168.1.1"
  sshkeys   = local.ssh_public_keys

  scsihw = "virtio-scsi-pci"
  disks {
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = "64G"
          storage = "local-lvm"
        }
      }
    }
  }

  vga {
    type = "std"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}
