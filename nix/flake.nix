{
  description = "NixOS Server Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # for creating LXC templates
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/v1.9.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    disko,
    ...
  }: {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };

      host-b = {
        deployment = {
          targetHost = "192.168.1.54";
          targetUser = "nixos";
          buildOnTarget = true;
        };
        boot.isContainer = true;
        time.timeZone = "Asia/Tokyo";
        nix = {
          settings = {
            experimental-features = ["nix-command" "flakes"];
          };
        };

        systemd.suppressedSystemUnits = [
          "sys-fs-fuse-connections.mount"
          "sys-kernel-debug.mount"
          "dev-mqueue.mount"
        ];
      };
    };
    nixosConfigurations =
    let
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE65lCWo/lvkIpk2NEnXuOdmruKsPOZyzgndg7y/0Kgr"
      ];
      system = "x86_64-linux";
    in
    {
      lxc = nixos-generators.nixosGenerate {
        inherit system;
        modules = [
          { common.keys = keys; }
          ./modules/common/configuration.nix
          ./modules/lxc/configuration.nix
        ];
        format = "proxmox-lxc";
      };
      iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ({
            users.users = {
              nixos.openssh.authorizedKeys.keys = keys;
              root.openssh.authorizedKeys.keys = keys;
            };
            services.qemuGuest.enable = true;
          })
        ];
      };
    };
  };
}
