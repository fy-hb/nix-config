{ inputs, ... }:
with inputs;
{
  flake = {
    defaultModules = {
      imports = [
        ./default/nixpkgs.nix
#         home-manager.nixosModules.home-manager
        #sops-nix.homeManagerModules.sops
        #nix-index-database.homeModules.nix-index
      ];
    };
    homeModules = {
      imports = [
        ./default/nixconf-home.nix
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
    nixosModules.a = {
      imports = [
        ./default/nixconf.nix
        home-manager.nixosModules.home-manager
        impermanence.nixosModules.impermanence
      ];
    };
  };
  imports = [ ./loader.nix ];
}
