resource "oci_core_instance" "minecraft-amd-osaka" {
  availability_domain = data.oci_identity_availability_domain.ads.name
  compartment_id      = oci_identity_compartment.minecraft.id

  display_name = "minecraft-amd-osaka"

  shape = "VM.Standard.E2.1.Micro"
  shape_config {
    memory_in_gbs = 1
    ocpus = 1
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.osaka_minecraft_public.id
    assign_public_ip = true
    assign_ipv6ip = true
    ipv6address_ipv6subnet_cidr_pair_details {
      ipv6subnet_cidr = oci_core_subnet.osaka_minecraft_public.ipv6cidr_block
    }
  }

  source_details {
    # Oracle-Linux-9.5-2025.01.31-0
    source_id = "ocid1.image.oc1.ap-osaka-1.aaaaaaaaa3va3lj4rnwlb5a7xaiuohbdm63nm74dlz6ucydsi5t4ivislnka"
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr"
  }
}