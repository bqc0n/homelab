resource "oci_core_vcn" "osaka" {
  compartment_id = oci_identity_compartment.minecraft.id

  display_name = "vcn-osaka-minecraft-tf"

  cidr_blocks = ["172.16.0.0/16"]
  is_ipv6enabled = true

  freeform_tags = { "ManagedBy" = "Terraform" }
}

resource "oci_core_internet_gateway" "osaka" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka.id

  display_name = "igw-osaka-minecraft-tf"
  freeform_tags = { "ManagedBy" = "Terraform" }

  enabled = true
}

resource "oci_core_default_route_table" "osaka" {
  manage_default_resource_id = oci_core_vcn.osaka.default_route_table_id
  compartment_id = oci_identity_compartment.minecraft.id
  route_rules {
    network_entity_id = oci_core_internet_gateway.osaka.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
  route_rules {
    network_entity_id = oci_core_internet_gateway.osaka.id
    destination = "::/0"
    destination_type = "CIDR_BLOCK"
  }

  route_rules {
    network_entity_id = oci_core_drg.osaka.id
    destination = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "osaka_public" {
  cidr_block     = "172.16.0.0/24"
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka.id
  ipv6cidr_block = replace(oci_core_vcn.osaka.ipv6cidr_blocks[0], "/56", "/64")
  security_list_ids = [
    oci_core_vcn.osaka.default_security_list_id,
    oci_core_security_list.osaka_public.id,
  ]

  display_name = "subnet-osaka-minecraft-public-tf"
  freeform_tags = { "ManagedBy" = "Terraform" }
}

resource "oci_core_security_list" "osaka_public" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka.id

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