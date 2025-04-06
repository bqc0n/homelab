data "oci_core_ipsec_connection_tunnels" "ipsec_ix2215_tunnels" {
  ipsec_id = oci_core_ipsec.ipsec_ix2215.id
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec_ix2215_config" {
  for_each = { 0 = "Alpha", 1 = "Beta" }
  ipsec_id  = oci_core_ipsec.ipsec_ix2215.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.ipsec_ix2215_tunnels.ip_sec_connection_tunnels[each.key].id
  display_name = "NEC IX 2215-1 IPSec Tunnel - ${each.value}"
  routing = "BGP"
  ike_version = "V2"
  bgp_session_info {
    customer_bgp_asn = "65000"
    oracle_interface_ip = "10.9.16.${each.key * 2}/31"
    customer_interface_ip = "10.9.16.${each.key * 2 + 1}/31"
  }
  oracle_can_initiate = "RESPONDER_ONLY"
  phase_one_details { lifetime = 7200 }
  phase_two_details { lifetime = 7200 }
}
