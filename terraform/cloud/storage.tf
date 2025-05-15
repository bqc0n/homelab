data  "oci_objectstorage_namespace" "this" {
  compartment_id = oci_identity_compartment.minecraft.id
}

resource "oci_objectstorage_bucket" "backup" {
  compartment_id = oci_identity_compartment.minecraft.id
  name           = "backup"
  namespace      = data.oci_objectstorage_namespace.this.namespace
}