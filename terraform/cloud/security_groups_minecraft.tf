resource "oci_core_network_security_group" "inbound_minecraft" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka.id

  display_name = "Inbound for Minecraft servers"
}

resource "oci_core_network_security_group_security_rule" "inbound_minecraft_tcp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_minecraft.id
  protocol                  = "6" # TCP
  source = each.value
  tcp_options {
    destination_port_range {
      max = 27140
      min = 27140
    }
  }
}