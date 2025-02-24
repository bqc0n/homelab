locals {
  hosts = [
    {
      hostname = "k8s-worker-01",
      node     = "pve01",
      ipv4     = "192.168.1.61",
      cores    = 4,
      memoryMi = 24576,
    },
    {
      hostname = "k8s-worker-02",
      node     = "pve02",
      ipv4     = "192.168.1.62",
      cores    = 16,
      memoryMi = 24576,
    },
    {
      hostname = "k8s-worker-03",
      node     = "pve03",
      ipv4     = "192.168.1.63",
      cores    = 6,
      memoryMi = 24576,
    },
  ]
}

module "k8s" {
  source = "../modules/k8s-proxmox"

  template = "ubuntu-24.04-template"
  ssh_keys = local.ssh_public_keys

  gateway    = "192.168.1.1"
  nameserver = "2606:4700:4700::1112 2606:4700:4700::1002 1.1.1.2 1.0.0.2"
  hosts      = local.hosts
  vmid_start = 1001
  specs = {
    sockets = 1,
    storage = "local-lvm",
    size    = "32G",
    bridge  = "vmbr0",
  }
}

resource "proxmox_vm_qemu" "k8s_master_ha" {
  vmid = 1000
  name = "k8s-master-ha"
  vm_state = "running"
  agent = 1

  target_node = "pve02"
  onboot           = true
  automatic_reboot = true
  cores = 4
  sockets = 1
  memory = 8192
  tablet  = false
  scsihw  = "virtio-scsi-pci"

  clone = "ubuntu24.04-template-ceph"
  full_clone = false
  os_type = "cloud-init"
  boot    = "order=scsi0"
  nameserver = "2606:4700:4700::1112 2606:4700:4700::1002 1.1.1.2 1.0.0.2"
  ipconfig0 = "ip=192.168.1.60/24,gw=192.168.1.1"

  sshkeys = local.ssh_public_keys

  hastate = "started"

  ciuser = "ubuntu"
  cipassword = data.sops_file.secrets.data["password.myself"]

  serial {
    id   = 0
    type = "socket"
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
        cloudinit {
          storage = "vm"
        }
      }
    }
  }
}