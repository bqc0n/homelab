resource "oci_core_drg" "osaka" {
  compartment_id = oci_identity_compartment.minecraft.id
}

resource "oci_core_cpe" "nec_ix_2215_1" {
  compartment_id = oci_identity_compartment.minecraft.id
  ip_address     = data.sops_file.secrets.data["home_public_ip"]
  display_name = "IX 2215 - 1"
}

resource "oci_core_cpe" "nec_ix_2105_1" {
  compartment_id = oci_identity_compartment.minecraft.id
  ip_address     = data.sops_file.secrets.data["home_public_ip"]
  display_name = "IX 2105 - 1"
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
  display_name = "NEC IX IPSec - Alpha"
  drg_id       = oci_core_drg.osaka.id
  static_routes = []
}

resource "oci_core_ipsec" "ipsec_ix2105" {
  compartment_id            = oci_identity_compartment.minecraft.id
  cpe_id                    = oci_core_cpe.nec_ix_2105_1.id
  cpe_local_identifier      = "ix2105-01.bqc0n.internal"
  cpe_local_identifier_type = "HOSTNAME"
  display_name = "NEC IX IPSec - Beta"
  drg_id       = oci_core_drg.osaka.id
  static_routes = []
}
