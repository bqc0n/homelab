resource "oci_core_vcn" "osaka_minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id

  display_name = "vcn-osaka-minecraft-tf"

  cidr_blocks = ["172.16.0.0/16"]
  is_ipv6enabled = true

  freeform_tags = {
    "ManagedBy" = "Terraform"
  }
}

resource "oci_core_internet_gateway" "osaka_minecraft_igw" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id

  display_name = "igw-osaka-minecraft-tf"

  enabled = true
}

resource "oci_core_default_route_table" "osaka_minecraft_default_route_table" {
  manage_default_resource_id = oci_core_vcn.osaka_minecraft.default_route_table_id
  compartment_id = oci_identity_compartment.minecraft.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.osaka_minecraft_igw.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
  route_rules {
    network_entity_id = oci_core_internet_gateway.osaka_minecraft_igw.id
    destination = "::/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "osaka_minecraft_public" {
  cidr_block     = "172.16.0.0/24"
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id
  ipv6cidr_block = replace(oci_core_vcn.osaka_minecraft.ipv6cidr_blocks[0], "/56", "/64")

  display_name = "subnet-osaka-minecraft-public-tf"
}