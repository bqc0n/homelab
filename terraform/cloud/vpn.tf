resource "oci_core_drg" "osaka" {
  compartment_id = oci_identity_compartment.minecraft.id
}

resource "oci_core_cpe" "nec_ix_sol" {
  compartment_id = oci_identity_compartment.minecraft.id
  ip_address     = data.sops_file.secrets.data["home_public_ip"]
  display_name = "IX2215 Sol"
}

resource "oci_core_drg_attachment" "osaka" {
  drg_id = oci_core_drg.osaka.id
  display_name = "Osaka VCN DRG Attachment"
  network_details {
    id = oci_core_vcn.osaka.id
    type = "VCN"
  }
}

resource "oci_core_ipsec" "ipsec_sol" {
  compartment_id            = oci_identity_compartment.minecraft.id
  cpe_id                    = oci_core_cpe.nec_ix_sol.id
  cpe_local_identifier      = "necix-sol.bqc0n.internal"
  cpe_local_identifier_type = "HOSTNAME"
  display_name = "IPsec Sol"
  drg_id       = oci_core_drg.osaka.id
  static_routes = ["192.168.1.0/24"]
}
