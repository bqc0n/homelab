{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    common = with lib; {
      keys = mkOption {
        type = types.listOf types.str;
        description = "SSH keys";
      };
    };
  };

  config = {
    nix.settings.auto-optimise-store = true;

    services.openssh = {
      enable = true;
      settings = {
        PubkeyAuthentication = true;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        GSSAPIAuthentication = false;
        ChallengeResponseAuthentication = false;
        PermitEmptyPasswords = false;

        PermitRootLogin = "no";
      };
      hostKeys = [
        {
          path = "/persist/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    nix.settings.trusted-users = [ "nixos" ];
    users.users.nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = config.common.keys;
    };
    security.sudo.wheelNeedsPassword = false;

    programs.bash.shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      llart = "eza -la";
      tree = "eza -T";
      ngc = "sudo nix-collect-garbage -d --verbose";
      v = "nvim";
    };

    environment.systemPackages = with pkgs; [
      bind
      eza
      htop-vim
      inetutils
      lsof
      ncdu
      ripgrep
      tmux
      neovim
    ];

# Todo
#    sops = {
#      defaultSopsFile = ../../secrets/secrets.sops.yaml;
#      defaultSopsFormat = "yaml";
#      age.keyFile = "/persist/var/lib/sops/age/server-side-key.txt";
#      age.sshKeyPaths = [ ];
#      gnupg.sshKeyPaths = [ ];
#    };

    system.stateVersion = "24.05";
  };
}