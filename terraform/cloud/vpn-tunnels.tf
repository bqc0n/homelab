data "oci_core_ipsec_connection_tunnels" "ipsec_sol_tunnels" {
  ipsec_id = oci_core_ipsec.ipsec_sol.id
}

resource "oci_core_ipsec_connection_tunnel_management" "ipsec_sol" {
  for_each = { 0 = "Alpha", 1 = "Beta" }
  ipsec_id  = oci_core_ipsec.ipsec_sol.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.ipsec_sol_tunnels.ip_sec_connection_tunnels[each.key].id
  display_name = "IPSec Tunnel Sol - ${each.value}"
  routing = "BGP"
  ike_version = "V2"
  bgp_session_info {
    customer_bgp_asn = "65000"
    customer_interface_ip = "169.254.255.${each.key * 2}/31"
    oracle_interface_ip = "169.254.255.${each.key * 2 + 1}/31"
  }
  oracle_can_initiate = "RESPONDER_ONLY"
  phase_one_details { lifetime = 28800 }
  phase_two_details { lifetime = 7200 }
  shared_secret = data.sops_file.secrets.data["oci_sol_psk_${each.key}"]
}
