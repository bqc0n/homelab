terraform {
  backend "s3" {
    bucket                      = "terraform-backend"
    key                         = "terraform/cloud.tfstate"
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
    oci = {
      source  = "oracle/oci"
      version = "7.27.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
}

provider "sops" {}

data "sops_file" "secrets" {
  source_file = "oci-secrets.sops.yaml"
}

provider "oci" {
  private_key = data.sops_file.secrets.data["oci_api_key"]
  fingerprint      = "91:67:b5:8d:b4:0a:cc:ff:c3:3c:a8:28:d3:82:67:18"
  user_ocid        = "ocid1.user.oc1..aaaaaaaaz2ccazsgfufncee7uqjus66ab4mzeo4y6jvlgu7qkmfdlnnjlhka"
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaa7rskwsyup6km52l5idinwoszkj3l5fxr3x5dvfmmr3lvoe4e3csa"
  region           = "ap-osaka-1"
}
