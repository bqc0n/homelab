output "minecraft-amd-osaka-public-ipv4" {
  value = oci_core_instance.minecraft-amd-osaka.public_ip
}

output "minecraft-amd-osaka-ipv6-GUA" {
  value = oci_core_instance.minecraft-amd-osaka.create_vnic_details[0].ipv6address_ipv6subnet_cidr_pair_details[0].ipv6address
}