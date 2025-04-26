{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/tcurdt.keys";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, disko, ... }@inputs:
    let
    in
    # systems = [ "x86_64-linux" ];
    # forAllSystems = nixpkgs.lib.genAttrs systems;
    {

      # packages = forAllSystems (system: import nixpkgs.legacyPackages.${system});

      nixosConfigurations = {
        base = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./machines/base
            disko.nixosModules.disko
            {
              # disko.enableConfig = true;
              imports = [ ./machines/base/disko.nix ];
            }
          ];
        };
      };
    };
}
