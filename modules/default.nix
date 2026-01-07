{ inputs, ... }:
with inputs;
{
  flake.homeModules = {
    imports = [
      ./default/nixpkgs.nix
      ./default/utils.nix
      self.mymodules.app
      self.mymodules.sys
      self.mymodules.lang
      sops-nix.homeManagerModules.sops
      nix-index-database.homeModules.nix-index
    ];
  };
  imports = [ ./loader.nix ];
}
