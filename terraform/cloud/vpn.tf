import {
  id = "ocid1.cpe.oc1.ap-osaka-1.aaaaaaaaly5ffppuxlirgu6ew6juuufvjdu2aiqwaneycxj7pocghwawnaua"
  to = oci_core_cpe.nec-ix-2215-1
}

resource "oci_core_drg" "osaka_minecraft_drg" {
  compartment_id = oci_identity_compartment.minecraft.id
}

resource "oci_core_cpe" "nec-ix-2215-1" {
  compartment_id = oci_identity_compartment.minecraft.id
  ip_address     = data.sops_file.secrets.data["home_public_ip"]
  display_name = "NEC IX 2215 - 1"
}

resource "oci_core_drg_attachment" "osaka_minecraft_drg_attachment" {
  drg_id = oci_core_drg.osaka_minecraft_drg.id
}

resource "oci_core_drg_attachment" "osaka_minecraft_drg_attachment" {
  drg_id = oci_core_drg.osaka_minecraft_drg.id
  display_name = "drg-attachment-osaka-minecraft-tf"
}