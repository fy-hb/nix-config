{ inputs, ... }:
with inputs;
{
  flake = {
    defaultModules = {
      imports = [
        ./default/nixpkgs.nix
        #sops-nix.homeManagerModules.sops
        #nix-index-database.homeModules.nix-index
      ];
    };
    homeModules = {
      imports = [
        self.mymodules.app
        self.mymodules.lang
      ];
    };
    darwinModules = {
      imports = [
        self.mymodules.sys
        home-manager.darwinModules.home-manager
      ];
    };
  };
  imports = [ ./loader.nix ];
}
