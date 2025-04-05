terraform {
  backend "s3" {
    bucket                      = "terraform-backend"
    key                         = "terraform/cloud/terraform.tfstate"
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
      version = "6.32.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
  }
}

provider "sops" {}

data "sops_file" "secrets" {
  source_file = "oci-secrets.yaml"
}

provider "oci" {
  private_key = data.sops_file.secrets.data["oci_private_key"]
  fingerprint      = "70:ed:5c:d1:59:c5:60:e2:9d:c5:24:de:af:01:f4:d2"
  user_ocid        = "ocid1.user.oc1..aaaaaaaa5ymwf4qk3cn56nhwyxj6ockkr6rlrgwaw36d2encnht2rtwx6nra"
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaa7rskwsyup6km52l5idinwoszkj3l5fxr3x5dvfmmr3lvoe4e3csa"
  region           = "ap-osaka-1"
}
