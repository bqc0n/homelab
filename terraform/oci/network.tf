resource "oci_core_vcn" "osaka_minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id

  display_name = "vcn-osaka-minecraft-tf"

  cidr_blocks = ["172.16.0.0/16"]
  is_ipv6enabled = true

  freeform_tags = {
    "ManagedBy" = "Terraform"
  }
}

resource "oci_core_subnet" "osaka_minecraft_public" {
  cidr_block     = "172.16.0.0/24"
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id
  ipv6cidr_block = replace(oci_core_vcn.osaka_minecraft.ipv6cidr_blocks[0], "/56", "/64")

  display_name = "subnet-osaka-minecraft-public-tf"
}