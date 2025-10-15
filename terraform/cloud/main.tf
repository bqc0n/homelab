data "oci_identity_availability_domain" "ads" {
  compartment_id = oci_identity_compartment.minecraft.id
  ad_number = 1
}

module "monitoring" {
  source = "./modules/monitoring"
  compartment_id = oci_identity_compartment.minecraft.id
}