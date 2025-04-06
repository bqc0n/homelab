resource "oci_core_vcn" "osaka_minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id

  display_name = "vcn-osaka-minecraft-tf"

  cidr_blocks = ["172.16.0.0/16"]
  is_ipv6enabled = true

  freeform_tags = { "ManagedBy" = "Terraform" }
}

resource "oci_core_internet_gateway" "osaka_minecraft_igw" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id

  display_name = "igw-osaka-minecraft-tf"
  freeform_tags = { "ManagedBy" = "Terraform" }

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

  route_rules {
    network_entity_id = oci_core_drg.osaka_minecraft_drg.id
    description = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
  }
  freeform_tags = { "ManagedBy" = "Terraform" }
}

resource "oci_core_subnet" "osaka_minecraft_public" {
  cidr_block     = "172.16.0.0/24"
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id
  ipv6cidr_block = replace(oci_core_vcn.osaka_minecraft.ipv6cidr_blocks[0], "/56", "/64")
  security_list_ids = [
    oci_core_vcn.osaka_minecraft.default_security_list_id,
    oci_core_security_list.osaka_minecraft_public_security_list.id,
  ]

  display_name = "subnet-osaka-minecraft-public-tf"
  freeform_tags = { "ManagedBy" = "Terraform" }
}

resource "oci_core_security_list" "osaka_minecraft_public_security_list" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id

  display_name = "Osaka Minecraft Public Security List"

  freeform_tags = { "ManagedBy" = "Terraform" }

  dynamic "ingress_security_rules" {
    for_each = ["0.0.0.0/0", "::/0"]
    content {
      protocol = 6 # TCP
      source   = ingress_security_rules.value
      stateless = true
      description = "Minecraft Server Ports"

      tcp_options {
        min = 27135
        max = 27138
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = ["0.0.0.0/0", "::/0"]
    content {
      protocol = 6 # TCP
      source   = ingress_security_rules.value
      stateless = true
      description = "Minecraft TOB SFTP"

      tcp_options {
        min = 12303
        max = 12303
      }
    }
  }
}