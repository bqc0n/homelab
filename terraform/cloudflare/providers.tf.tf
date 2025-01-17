terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "1.1.1"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

data "sops_file" "secrets" {
  source_file = "secrets.enc.yml"
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare.api_token"]
}