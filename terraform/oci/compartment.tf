resource "oci_identity_compartment" "minecraft" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaa7rskwsyup6km52l5idinwoszkj3l5fxr3x5dvfmmr3lvoe4e3csa"
  description = "Compartment for Minecraft Related Resources"
  name        = "minecraft"
}