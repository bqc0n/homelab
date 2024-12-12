locals {
  # 1 master and 1 workerでひとまずk8sに慣れる
  hosts = [
    {
      hostname = "k8s-master",
      node     = "pve02",
      ipv4     = "192.168.1.60",
    },
    {
      hostname = "k8s-worker-01",
      node     = "pve02",
      ipv4     = "192.168.1.61",
    },
    # {
    #   hostname = "k8s-worker-02",
    #   node     = "pve02",
    #   ipv4     = "192.168.1.62",
    # },
    # {
    #   hostname = "k8s-worker-03",
    #   node     = "pve01",
    #   ipv4     = "192.168.1.63",
    # },
  ]
}

module "k8s" {
  source = "../modules/k8s-proxmox"

  template = "ubuntu-24.04-template"
  ssh_keys = local.ssh_public_keys

  gateway = "192.168.1.1"
  nameserver = "192.168.1.2"
  hosts = local.hosts
  vmid_start = 1000
  specs = {
    cores = 4,
    sockets = 1,
    memory = 8192,
    storage = "local-lvm",
    size = "32G",
    bridge = "vmbr0",
  }
}