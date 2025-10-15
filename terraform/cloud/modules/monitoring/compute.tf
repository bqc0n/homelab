resource "oci_core_instance" "mon3tr" {
  availability_domain = data.oci_identity_availability_domain.ad_1.name
  compartment_id      = var.compartment_id

  display_name = "Mon3tr"

  shape = "VM.Standard.E2.1.Micro"
  shape_config {
    memory_in_gbs = 1
    ocpus = 1
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.osaka_monitoring_public.id
    assign_public_ip = true
    assign_ipv6ip = true
    ipv6address_ipv6subnet_cidr_pair_details {
      ipv6address = "${replace(oci_core_subnet.osaka_monitoring_public.ipv6cidr_block, "/64", "")}2e"
    }

    nsg_ids = [
      oci_core_network_security_group.osakamon_inbound_http_https.id,
    ]
  }

  source_details {
    # Canonical-Ubuntu-24.04-2025.07.23-0
    source_id = "ocid1.image.oc1.ap-osaka-1.aaaaaaaakubn2okgusevio3dcanojxysaeod42dkey2tilbr7bfvkiconb6q"
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr"
  }
}

