{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/tcurdt.keys";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, disko, ... }@inputs:
    {
      nixosConfigurations = {
        base = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./machines/base
            disko.nixosModules.disko
          ];
        };
      };
    };
}
