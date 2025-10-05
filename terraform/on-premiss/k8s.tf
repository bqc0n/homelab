locals {
  hosts = [
    {
      hostname = "k8s-worker-01",
      node     = "pve01",
      ipv4     = "192.168.1.61",
      ipv6_ula = "fd76:913d:9525::61/64",
      cores    = 4,
      memoryMi = 8192,
    },
    {
      hostname = "k8s-worker-02",
      node     = "pve02",
      ipv4     = "192.168.1.62",
      ipv6_ula = "fd76:913d:9525::62/64",
      cores    = 16,
      memoryMi = 32768,
    },
    {
      hostname = "k8s-worker-03",
      node     = "pve03",
      ipv4     = "192.168.1.63",
      ipv6_ula = "fd76:913d:9525::63/64",
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
  nameserver = "192.168.1.1"
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

  cpu {
    type = "x86-64-v2-AES"
    cores = 4
    sockets = 1
  }

  target_node = "pve02"
  onboot           = true
  automatic_reboot = true
  memory = 6144
  tablet  = false
  scsihw  = "virtio-scsi-pci"

  clone = "ubuntu-24.04-template-ceph"
  full_clone = false
  os_type = "cloud-init"
  boot    = "order=scsi0"
  nameserver = "192.168.1.1"
  ipconfig0 = "ip=192.168.1.60/24,gw=192.168.1.1"
  ipconfig1 = "ipv6=fd76:913d:9525::60/64"

  sshkeys = local.ssh_public_keys

  hastate = "started"

  ciuser = "ubuntu"
  cipassword = data.sops_file.secrets.data["password.myself"]

  serial {
    id   = 0
    type = "socket"
  }

  network {
    id    = 0
    model = "virtio"
    bridge = "vmbr0"
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