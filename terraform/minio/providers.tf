terraform {
  backend "s3" {
    bucket                      = "terraform-backend"
    key                         = "terraform/minio.tfstate"
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
      version = "1.3.0"
    }
    minio = {
      source = "aminueza/minio"
      version = "3.11.5"
    }
  }
}

provider "sops" {}

data "sops_file" "secrets" {
  source_file = "minio-secrets.sops.yaml"
}

provider "minio" {
  minio_server = "s4.bqc0n.com"
  minio_region = "tokyo-1"
  minio_ssl = true
  minio_user = data.sops_file.secrets.data["minio.user"]
  minio_password = data.sops_file.secrets.data["minio.password"]
}

