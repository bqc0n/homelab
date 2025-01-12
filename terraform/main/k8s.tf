locals {
  # 1 master and 1 workerでひとまずk8sに慣れる
  hosts = [
    {
      hostname = "k8s-master",
      node     = "pve02",
      ipv4     = "192.168.1.60",
      cores    = 4,
      memoryMi = 8192,
    },
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
      memoryMi = 32768,
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
  nameserver = "2606:4700:4700::1112,2606:4700:4700::1002,1.1.1.2,1.0.0.2"
  hosts      = local.hosts
  vmid_start = 1000
  specs = {
    sockets = 1,
    storage = "local-lvm",
    size    = "32G",
    bridge  = "vmbr0",
  }
}