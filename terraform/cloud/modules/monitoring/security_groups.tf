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

