resource "oci_core_vcn" "osaka" {
  compartment_id = oci_identity_compartment.minecraft.id

  display_name = "vcn-osaka-minecraft-tf"

  cidr_blocks = ["172.16.0.0/16"]
  is_ipv6enabled = true

  freeform_tags = {
    "ManagedBy" = "Terraform"
  }
}