{
  # pkgs,
  inputs,
  ...
}:
{
  system.stateVersion = "23.11";

  networking.hostName = "base";
  networking.domain = "nixos";

  imports = [

    ../../hardware/hetzner.nix

    inputs.disko.nixosModules.disko
    ./disko.nix

    ../../modules/server.nix
    ../../modules/users.nix

    ../../users/root.nix

  ];
}
