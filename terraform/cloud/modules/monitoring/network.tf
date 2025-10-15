resource "oci_core_vcn" "osaka_monitoring" {
  compartment_id = var.compartment_id

  display_name = "Monitoring | Osaka VCN"

  cidr_blocks = ["172.16.0.0/24"]
  is_ipv6enabled = true
  dns_label = "osakamon"
}

resource "oci_core_internet_gateway" "osaka_monitoring" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.osaka_monitoring.id

  display_name = "Monitoring | Osaka IGW"

  enabled = true
}

resource "oci_core_default_route_table" "osaka_monitoring" {
  manage_default_resource_id = oci_core_vcn.osaka_monitoring.default_route_table_id
  compartment_id = var.compartment_id
  route_rules {
    network_entity_id = oci_core_internet_gateway.osaka_monitoring.id
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
  route_rules {
    network_entity_id = oci_core_internet_gateway.osaka_monitoring.id
    destination = "::/0"
    destination_type = "CIDR_BLOCK"
  }
}

resource "oci_core_subnet" "osaka_monitoring_public" {
  cidr_block     = "172.16.0.0/27"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.osaka_monitoring.id
  ipv6cidr_block = replace(oci_core_vcn.osaka_monitoring.ipv6cidr_blocks[0], "/56", "/64")
  security_list_ids = [
    oci_core_vcn.osaka_monitoring.default_security_list_id
  ]

  display_name = "Monitoring | Public Subnet 1"
}
