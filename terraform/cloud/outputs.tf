output "minecraft_amd_osaka_public_ipv4" {
  value = oci_core_instance.minecraft-amd-osaka.public_ip
}

output "minecraft_amd_osaka_ipv6_GUA" {
  value = oci_core_instance.minecraft-amd-osaka.create_vnic_details[0].ipv6address_ipv6subnet_cidr_pair_details[0].ipv6address
}

output "ipsec_ip_address" {
  value = [
    oci_core_ipsec_connection_tunnel_management.ipsec_ix2215_config[0].vpn_ip,
    oci_core_ipsec_connection_tunnel_management.ipsec_ix2215_config[1].vpn_ip,
  ]
}