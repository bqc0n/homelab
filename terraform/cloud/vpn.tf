import {
  id = "ocid1.cpe.oc1.ap-osaka-1.aaaaaaaaly5ffppuxlirgu6ew6juuufvjdu2aiqwaneycxj7pocghwawnaua"
  to = oci_core_cpe.nec_ix_2215_1
}

import {
  id = "ocid1.ipsecconnection.oc1.ap-osaka-1.aaaaaaaafpm5777g2n2msdizvhcibgkwd6gbwzclwd5nx54rhantok6wavra"
  to = oci_core_ipsec.ipsec_ix2215
}

resource "oci_core_drg" "osaka" {
  compartment_id = oci_identity_compartment.minecraft.id
}

resource "oci_core_cpe" "nec_ix_2215_1" {
  compartment_id = oci_identity_compartment.minecraft.id
  ip_address     = data.sops_file.secrets.data["home_public_ip"]
  display_name = "NEC IX 2215 - 1"
}

resource "oci_core_drg_attachment" "osaka" {
  drg_id = oci_core_drg.osaka.id
  display_name = "Osaka VCN DRG Attachment"
  network_details {
    id = oci_core_vcn.osaka.id
    type = "VCN"
  }
}

resource "oci_core_ipsec" "ipsec_ix2215" {
  compartment_id            = oci_identity_compartment.minecraft.id
  cpe_id                    = oci_core_cpe.nec_ix_2215_1.id
  cpe_local_identifier      = "ix2215-01.bqc0n.internal"
  cpe_local_identifier_type = "HOSTNAME"
  display_name = "NEC IX IPSec"
  drg_id       = oci_core_drg.osaka.id
  static_routes = []
}

