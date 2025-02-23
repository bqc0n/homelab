# resource "oci_core_instance" "minecraft-arm" {
#   availability_domain = "Nore:AP-OSAKA-1-AD-1"
#   compartment_id      = local.minecraft_compartment_id
#
#   display_name = "minecraft-arm"
#
#   shape = "VM.Standard.A1.Flex"
#   shape_config {
#     memory_in_gbs = "6"
#     ocpus = "1"
#   }
#
#   create_vnic_details {
#     assign_ipv6ip = "true"
#     assign_private_dns_record = "true"
#     assign_public_ip = "true"
#     ipv6address_ipv6subnet_cidr_pair_details {
#       ipv6subnet_cidr = "2603:c023:000d:983a:0000:0000:0000:0000/64"
#     }
#     subnet_id = "ocid1.subnet.oc1.ap-osaka-1.aaaaaaaadf5q4ah5tgmlnlnfaypwqz5mlsc75rkg2f6xnjmrh3qhkjcuvtfa"
#   }
#
#   source_details {
#     source_id = "ocid1.image.oc1.ap-osaka-1.aaaaaaaatb57x5omvpzjsxpdiwbudmufr4othqhupanwo5nvxzpvjz5syuga"
#     source_type = "image"
#   }
#
# }