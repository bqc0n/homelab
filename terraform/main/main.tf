locals {
  ssh_public_keys = <<-EOT
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr
  EOT
  nameserver = "1.1.1.1"
}

resource "proxmox_lxc" "file_server" {
  vmid            = 302
  target_node     = "pve01"
  hostname        = "FileServer"
  ostemplate      = "local:vztmpl/ubuntu-24.04-2_amd64.tar.zst"
  password        = data.sops_file.secrets.data["password.myself"]
  ssh_public_keys = local.ssh_public_keys
  unprivileged    = true
  nameserver      = local.nameserver

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


resource "proxmox_vm_qemu" "docker-playground" {
  vmid = 203
  name = "docker-playground"
  vm_state = "running"
  agent = 0

  target_node      = "pve02"
  onboot           = true
  automatic_reboot = true

  cores   = 8
  sockets = 1
  memory  = 16384
  tablet  = false
  scsihw  = "virtio-scsi-pci"

  clone   = "ubuntu-24.04-template"
  os_type = "cloud-init"
  boot    = "order=scsi0"

  nameserver = local.nameserver
  ipconfig0 = "ip=192.168.1.3/24,gw=192.168.1.1"

  sshkeys = local.ssh_public_keys

  serial {
    id   = 0
    type = "socket"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage    = "local-lvm"
          size       = "64G"
          emulatessd = true
          discard    = true
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    # id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }
}
