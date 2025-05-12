resource "proxmox_vm_qemu" "vyos" {
  for_each = toset(["1", "2", "3"])
  vmid = 1100 + each.key
  name = "vyos-${each.value}"
  vm_state = "running"
  agent = 1

  cpu_type = "x86-64-v2-AES"

  target_node = "pve02"
  onboot           = true
  automatic_reboot = true
  cores = 1
  sockets = 1
  memory = 2048
  tablet  = false
  scsihw  = "virtio-scsi-pci"


  full_clone = false
  boot    = "order=scsi0"
  nameserver = "192.168.1.1"
  ipconfig0 = "ip=192.168.1.11${each.value}/24,gw=192.168.1.1"

  sshkeys = local.ssh_public_keys

  ciuser = "vyos"
  cipassword = data.sops_file.secrets.data["password.myself"]

  serial {
    id   = 0
    type = "socket"
  }

  network {
    id = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  network {
    id = 1
    model = "virtio"
    bridge = "vmbr1"
  }

  network {
    id = 2
    model = "virtio"
    bridge = "vmbr1"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage    = "vm"
          size       = "32G"
          emulatessd = true
          discard    = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "vyos-1.5-stream-2025-Q1-generic-amd64.iso"
        }
      }
    }
  }
}
