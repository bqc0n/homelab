output "minecraft_amd_osaka_public_ipv4" {
  value = oci_core_instance.m2b.public_ip
}

output "minecraft_amd_osaka_ipv6_GUA" {
  value = oci_core_instance.m2b.create_vnic_details[0].ipv6address_ipv6subnet_cidr_pair_details[0].ipv6address
}


output "minecraft_amd_2b" {
  value = {
    ipv4 = oci_core_instance.m2b.public_ip
    ipv6 = oci_core_instance.m2b.create_vnic_details[0].ipv6address_ipv6subnet_cidr_pair_details[0].ipv6address
  }
}

output "minecraft_amd_2e" {
  value = {
    ipv4 = oci_core_instance.m2e.public_ip
    ipv6 = oci_core_instance.m2e.create_vnic_details[0].ipv6address_ipv6subnet_cidr_pair_details[0].ipv6address
  }
}

output "ipsec_ix2215_1_ip_address" {
  value = [
    oci_core_ipsec_connection_tunnel_management.ipsec_ix2215_config[0].vpn_ip,
    oci_core_ipsec_connection_tunnel_management.ipsec_ix2215_config[1].vpn_ip,
  ]
}

output "ipsec_ix2105_1_ip_address" {
  value = [
    oci_core_ipsec_connection_tunnel_management.ipsec_ix2105_config[0].vpn_ip,
    oci_core_ipsec_connection_tunnel_management.ipsec_ix2105_config[1].vpn_ip,
  ]
}
