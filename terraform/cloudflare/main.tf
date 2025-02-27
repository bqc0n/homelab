terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "1.1.1"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.0.0"
    }
  }
}

locals {
  account_id = "b10e567bb8146c35a101bec133d4a82f"
  zone_id = "d93d0e6db5167e4d4ead7c175f7bd158"
  domain = "bqc0n.com"
}

data "sops_file" "secrets" {
  source_file = "secrets.enc.yml"
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare.api_token"]
}