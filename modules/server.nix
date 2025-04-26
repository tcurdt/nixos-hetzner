{ pkgs, inputs, ... }:
{

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";

  zramSwap.enable = false;
  boot.tmp.cleanOnBoot = true;

  # packages trim down

  documentation.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  fonts.fontconfig.enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.defaultPackages = pkgs.lib.mkForce [ ]; # no default packages

  environment.systemPackages = [
    pkgs.nano
    pkgs.curl
    pkgs.gitMinimal
  ];

  # environment.sessionVariables = {
  #   FLAKE = "/etc/nixos/flake";
  # };

  environment.persistence."/persistent" = {
    hideMounts = true;
    # files = [
    #   "/etc/machine-id"
    #   {
    #     file = "/var/keys/secret_file";
    #     parentDirectory = {
    #       mode = "u=rwx,g=,o=";
    #     };
    #   }
    # ];
    directories = [
      {
        directory = "/var/lib/nixos";
        mode = "0755";
      }
      {
        directory = "/var/log";
        mode = "0755";
      }
      # {
      #   directory = "/secrets";
      #   mode = "0755";
      # }
      # { directory = "/etc/nixos";       mode="0755"; } # nixos system config files, can be considered optional
      # { directory = "/srv";             mode="0755"; } # service data

      # { directory = "/var/lib/influxdb2";  mode="0755"; }
      # { directory = "/var/lib/postgresql"; mode="0755"; }
      # { directory = "/var/lib/mysql";      mode="0755"; }

    ];
  };

  # ssh

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    extraConfig = ''
      IgnoreRhosts yes
      AllowTcpForwarding yes
      AllowAgentForwarding yes
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

}
