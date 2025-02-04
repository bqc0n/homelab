terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4" # rc6 has a bug in LXC
    }
    sops = {
      source = "carlpett/sops"
      version = "1.1.1"
    }
  }
}

provider "proxmox" {
  pm_api_url = data.sops_file.secrets.data["proxmox.api_url"]
  pm_api_token_id = data.sops_file.secrets.data["proxmox.token_id"]
  pm_api_token_secret = data.sops_file.secrets.data["proxmox.token_secret"]
  # pm_tls_insecure = true
}