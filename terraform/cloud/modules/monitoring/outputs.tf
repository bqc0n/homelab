output "compute_mon3tr" {
  value = {
    ipv4 = oci_core_instance.mon3tr.public_ip
    ipv6 = oci_core_instance.mon3tr.create_vnic_details[0].ipv6address_ipv6subnet_cidr_pair_details[0].ipv6address
  }
}