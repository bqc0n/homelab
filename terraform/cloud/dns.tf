# data "oci_dns_resolvers" "osaka" {
#   compartment_id = oci_identity_compartment.minecraft.id
#   scope          = "PRIVATE"
# }
#
# resource "oci_dns_resolver_endpoint" "osaka" {
#   is_forwarding = true
#   is_listening  = false
#   name          = "endpoint_forward"
#   resolver_id   = data.oci_dns_resolvers.osaka.resolvers[0].id
#   subnet_id     = oci_core_subnet.osaka_public.id
# }