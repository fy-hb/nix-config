{ lib, pkgs, config, inputs, ... }:
let
  x11Fonts = pkgs.runCommand "X11-fonts" { preferLocalBuild = true; } ''
    data_path="$out"
    mkdir -p "$data_path"
    font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'

    find ${toString config.fonts.packages} -regex "$font_regexp" \
      -exec cp --no-preserve=mode '{}' "$data_path" \;
    cd "$data_path"
    ${pkgs.gzip}/bin/gunzip -f *.gz
    ${pkgs.mkfontscale}/bin/mkfontscale
    ${pkgs.mkfontscale}/bin/mkfontdir
    cat $(find ${pkgs.font-alias}/ -name fonts.alias) >fonts.alias
  '';
in
{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;
    channel.enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;
#     useXdg = true;
    nixPath = [
      "nixpkgs=/etc/nix/inputs/nixpkgs"
    ];
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
      use-xdg-base-directories = true;
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
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  environment.etc."x11fonts".source = "${x11Fonts}";
}
