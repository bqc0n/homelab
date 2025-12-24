resource "oci_core_instance" "m2b" {
  availability_domain = data.oci_identity_availability_domain.ads.name
  compartment_id      = oci_identity_compartment.minecraft.id

  display_name = "2B"

  shape = "VM.Standard.E2.1.Micro"
  shape_config {
    memory_in_gbs = 1
    ocpus = 1
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.osaka_public.id
    assign_public_ip = true
    assign_ipv6ip = true
    ipv6address_ipv6subnet_cidr_pair_details {
      ipv6address = "${replace(oci_core_subnet.osaka_public.ipv6cidr_block, "/64", "")}2b"
    }
    nsg_ids = [
      oci_core_network_security_group.inbound_http_https.id,
      oci_core_network_security_group.inbound_ssh.id,
      oci_core_network_security_group.inbound_minecraft.id,
    ]
  }

  source_details {
    # Oracle-Linux-9.5-2025.01.31-0
    source_id = "ocid1.image.oc1.ap-osaka-1.aaaaaaaaa3va3lj4rnwlb5a7xaiuohbdm63nm74dlz6ucydsi5t4ivislnka"
    source_type = "image"
    boot_volume_size_in_gbs = "47"
  }

  metadata = {
    ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr"
  }
}

resource "oci_core_instance" "a2" {
  availability_domain = data.oci_identity_availability_domain.ads.name
  compartment_id      = oci_identity_compartment.minecraft.id

  display_name = "A2"
  shape = "VM.Standard.A1.Flex"
  shape_config {
    memory_in_gbs = 24
    ocpus = 4
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.osaka_public.id
    assign_public_ip = true
    assign_ipv6ip = true
    ipv6address_ipv6subnet_cidr_pair_details {
      ipv6address = "${replace(oci_core_subnet.osaka_public.ipv6cidr_block, "/64", "")}a2"
    }
    nsg_ids = [
      oci_core_network_security_group.inbound_http_https.id,
      oci_core_network_security_group.inbound_minecraft_2.id
    ]
  }

  source_details {
    # you can get image ids here https://docs.oracle.com/en-us/iaas/images/index.htm
    # Canonical-Ubuntu-24.04-aarch64-2025.07.23-0
    source_id = "ocid1.image.oc1.ap-osaka-1.aaaaaaaaglaxxdyc7fwf77e4lq26h2nhik52d2bmxjuiqe5mzndw3zpmj4hq"
    source_type = "image"
    boot_volume_size_in_gbs = "105"
  }

  metadata = {
    ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr"
  }
}