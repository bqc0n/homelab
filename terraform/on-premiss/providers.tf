terraform {
  backend "s3" {
    bucket                      = "terraform-backend"
    key                         = "terraform/on-premiss.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    access_key                  = ""
    secret_key                  = ""
    endpoints = { s3 = "https://b10e567bb8146c35a101bec133d4a82f.r2.cloudflarestorage.com" }
  }
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc9" # rc6 has a bug in LXC
    }
    sops = {
      source = "carlpett/sops"
      version = "1.2.0"
    }
  }
}

provider "proxmox" {
  pm_api_url = data.sops_file.secrets.data["proxmox.api_url"]
  pm_api_token_id = data.sops_file.secrets.data["proxmox.token_id"]
  pm_api_token_secret = data.sops_file.secrets.data["proxmox.token_secret"]
  pm_tls_insecure = true
}