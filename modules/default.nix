{ inputs, ... }:
with inputs;
{
  flake.homeModules = {
    imports = [
      ./utils.nix
      self.mymodules.app
      self.mymodules.nix
      self.mymodules.lang
      sops-nix.homeManagerModules.sops
      nix-index-database.homeModules.nix-index
    ];
  };
  imports = [ ./settings.nix ];
}

