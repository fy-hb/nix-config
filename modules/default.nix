{ inputs, ... }:
with inputs;
{
  flake.defaultModules = {
    imports = [
      ./default/nixpkgs.nix
    ];
  };
  flake.homeModules = {
    imports = [
      self.mymodules.app
      self.mymodules.sys
      self.mymodules.lang
      sops-nix.homeManagerModules.sops
      nix-index-database.homeModules.nix-index
    ];
  };
  imports = [ ./loader.nix ];
}
