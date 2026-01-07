{ config, inputs, ... }:
{
  flake = with inputs; {
    homeConfigurations.frost_ice = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./main/default.nix
        self.homeModules
      ];
      extraSpecialArgs = {
        system = "x86_64-linux";
        inherit inputs;
      };
    };
  };
}
