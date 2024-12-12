terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

resource "proxmox_vm_qemu" "k8s_node" {
  count = length(var.hosts)

  vmid = var.vmid_start + count.index
  name = var.hosts[count.index].hostname
  vm_state = "running"

  target_node      = var.hosts[count.index].node
  onboot           = true
  automatic_reboot = true

  cores   = var.specs.cores
  sockets = var.specs.sockets
  memory  = var.specs.memory
  tablet  = false
  agent   = 1
  scsihw  = "virtio-scsi-pci"

  clone   = var.template
  os_type = "cloud-init"
  boot    = "order=scsi0"

  nameserver = var.nameserver
  ipconfig0 = "ip=${var.hosts[count.index].ipv4}/24,gw=${var.gateway}"

  sshkeys = var.ssh_keys

  serial {
    id   = 0
    type = "socket"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage    = var.specs.storage
          size       = var.specs.size
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
    bridge  = var.specs.bridge
  }
}