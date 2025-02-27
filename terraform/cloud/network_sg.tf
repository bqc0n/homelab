resource "oci_core_network_security_group" "wireguard" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka_minecraft.id
  display_name = "Wireguard"

  freeform_tags = { "ManagedBy" = "Terraform" }
}

resource "oci_core_network_security_group_security_rule" "wireguard_ingress" {
  for_each = toset(["0.0.0.0/0", "::/0"])
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.wireguard.id
  protocol                  = "17" # UDP

  description = "Allow Wireguard Ingress traffic"

  source = each.value
  source_type = "CIDR_BLOCK"
  stateless = true
  udp_options {
    destination_port_range {
      max = 51820
      min = 51820
    }
  }
}
