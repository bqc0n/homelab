terraform {
  backend "s3" {
    bucket                      = "terraform-backend"
    key                         = "terraform/cloudflare.tfstate"
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
    sops = {
      source = "carlpett/sops"
      version = "1.2.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.6.0"
    }
  }
}

locals {
  account_id = "b10e567bb8146c35a101bec133d4a82f"
  zone_id = "d93d0e6db5167e4d4ead7c175f7bd158"
  domain = "bqc0n.com"
}

data "sops_file" "secrets" {
  source_file = "cf-secrets.sops.yaml"
}

data "terraform_remote_state" "cloud" {
  backend = "s3"
  config = {
    bucket                      = "terraform-backend"
    key                         = "terraform/cloud.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    access_key                  = data.sops_file.secrets.data["r2_access_key"]
    secret_key                  = data.sops_file.secrets.data["r2_secret_key"]
    endpoints = { s3 = "https://b10e567bb8146c35a101bec133d4a82f.r2.cloudflarestorage.com" }
  }
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare.api_token"]
}