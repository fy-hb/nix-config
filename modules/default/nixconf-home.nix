{
  lib,
  pkgs,
  config,
  ...
}:
{
  nix = {
    useXdg = true;
    assumeXdg = true;
    #     package = pkgs.lixPackageSets.latest.lix;
    #     channel.enable = false;
    #     registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [
      "nixpkgs=/etc/nix/inputs/nixpkgs"
    ];
    /*
      settings = {
            trusted-users = [
              config.username
              "@wheel"
              "@admin"
              "root"
            ];
            experimental-features = [
              "nix-command"
              "flakes"
            ];
            #use-xdg-base-directories = true;
            substituters = [
              "https://cache.nixos.org"
      #         "https://cache.garnix.io"
            ];
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #         "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
          };
          #extraOptions = "!include ${config.sops.templates.nixconf-gh.path}";
          gc = {
            automatic = true;
          };
    */
  };
  home.preferXdgDirectories = true;
  #   environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
}
