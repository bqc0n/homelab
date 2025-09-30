provider "sops" {}

data "sops_file" "secrets" {
  source_file = "onp-secrets.sops.yaml"
}