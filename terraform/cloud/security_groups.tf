locals {
  anywhere_cidrs = toset(["0.0.0.0/0", "::/0"])
}

# Allow HTTP (80) and HTTPS (443) Ports
resource "oci_core_network_security_group" "inbound_http_https" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka.id

  display_name = "Allow HTTP and HTTPS"
}

resource "oci_core_network_security_group_security_rule" "inbound_http_tcp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_http_https.id
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

resource "oci_core_network_security_group_security_rule" "inbound_https_tcp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_http_https.id
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

resource "oci_core_network_security_group_security_rule" "inbound_https_udp" {
  for_each = local.anywhere_cidrs
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_http_https.id
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

# SSH 2222 Port
resource "oci_core_network_security_group" "inbound_ssh" {
  compartment_id = oci_identity_compartment.minecraft.id
  vcn_id         = oci_core_vcn.osaka.id
  display_name = "Allow SSH 2222"
}
resource "oci_core_network_security_group_security_rule" "inbound_ssh_tcp" {
  for_each = local.anywhere_cidrs

  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.inbound_ssh.id
  protocol                  = "6" # TCP
  stateless = true

  source = each.value
  tcp_options {
    destination_port_range {
      max = 2222
      min = 2222
    }
  }
}
