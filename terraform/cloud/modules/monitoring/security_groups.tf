locals {
  anywhere_cidrs = toset(["0.0.0.0/0", "::/0"])
}

# HTTP/HTTPS for Osaka Monitoring
resource "oci_core_network_security_group" "osakamon_inbound_http_https" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.osaka_monitoring.id

  display_name = "Allow HTTP and HTTPS"
}

resource "oci_core_network_security_group_security_rule" "osakamon_inbound_http_tcp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.osakamon_inbound_http_https.id
  protocol                  = "6" # TCP
  stateless = true

  source = each.value
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "osakamon_inbound_https_tcp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.osakamon_inbound_http_https.id
  protocol                  = "6" # TCP
  stateless = true

  source = each.value
  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "osakamon_inbound_https_udp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.osakamon_inbound_http_https.id
  protocol                  = "17" # UDP
  stateless = true

  source = each.value
  udp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}


# ICMP
resource "oci_core_network_security_group" "inbound_icmp" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.osaka_monitoring.id

  display_name = "Allow ALL ICMP"
}

resource "oci_core_network_security_group_security_rule" "inbound_icmp_v4" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_icmp.id
  protocol                  = "1" # ICMP
  stateless = true

  source = "0.0.0.0/0"
}

resource "oci_core_network_security_group_security_rule" "inbound_icmp_v6" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_icmp.id
  protocol                  = "58" # ICMPv6
  stateless = true

  source = "::/0"
}

# STUN
resource "oci_core_network_security_group" "inbound_stun" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.osaka_monitoring.id

  display_name = "Allow STUN"
}

resource "oci_core_network_security_group_security_rule" "inbound_stun" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_stun.id
  protocol                  = "17" # UDP
  stateless = true

  source = each.value
  udp_options {
    destination_port_range {
      max = 3478
      min = 3478
    }
  }
}
