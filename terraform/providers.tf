terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
    sops = {
      source = "carlpett/sops"
      version = "1.1.1"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = ">= 4.40.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = data.sops_file.secrets.data["proxmox.api_url"]
  pm_api_token_id = data.sops_file.secrets.data["proxmox.token_id"]
  pm_api_token_secret = data.sops_file.secrets.data["proxmox.token_secret"]
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare.api_token"]
}