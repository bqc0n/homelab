data "oci_identity_availability_domain" "ad_1" {
  compartment_id = var.compartment_id
  ad_number = 1
}
