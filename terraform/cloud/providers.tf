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
    endpoints = { s3 = "https://b10e567bb8146c35a101bec133d4a82f.r2.cloudflarestorage.com" }
  }
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "9.13.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }
}

provider "sops" {}

data "sops_file" "secrets" {
  source_file = "oci-secrets.sops.yaml"
}

provider "oci" {
  fingerprint      = "81:61:57:53:c4:06:8e:5f:6c:bc:c8:c8:87:8f:7a:f6"
  user_ocid        = "ocid1.user.oc1..aaaaaaaaz2ccazsgfufncee7uqjus66ab4mzeo4y6jvlgu7qkmfdlnnjlhka"
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaa7rskwsyup6km52l5idinwoszkj3l5fxr3x5dvfmmr3lvoe4e3csa"
  region           = "ap-osaka-1"
}
