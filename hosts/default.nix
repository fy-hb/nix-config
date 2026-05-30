{ inputs, ... }:
let
  inheritInto = key : val : { lib, ... } : { options = { sysfonts = lib.mkOption { default = val; }; }; };
  genUserConf = args :
  let
    username = args.username;
    server = args.server or false;
  in
    { lib, config, pkgs, ... }: {
      options = {
        username = lib.mkOption { default = username; };
        homePath = lib.mkOption {
          default = if config ? home then config.home.homeDirectory else config.users.users.${config.username}.home;
        };
        server = lib.mkOption {
          default = server;
        };
        inheritInto = lib.mkOption { default = inheritInto; };
#         x11Fonts = pkgs.runCommand "X11-fonts" { preferLocalBuild = true; } ''
#           data_path="$out"
#           mkdir -p "$data_path"
#           font_regexp='.*\.\(ttf\|ttc\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
#
#           find ${toString config.fonts.packages} -regex "$font_regexp" \
#             -exec cp --no-preserve=mode '{}' "$data_path" \;
#           cd "$data_path"
#           ${pkgs.gzip}/bin/gunzip -f *.gz
#           ${pkgs.mkfontscale}/bin/mkfontscale
#           ${pkgs.mkfontscale}/bin/mkfontdir
#           cat $(find ${pkgs.font-alias}/ -name fonts.alias) >fonts.alias
#         '';
        userConfModule = lib.mkOption {
          default = genUserConf args;
        };
      };
    };
in
{
  flake = with inputs; {
    nixosConfigurations."qwq" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs system; };
      modules = [
        ./pc/config.nix
        (genUserConf { username = "frost_ice"; })
        self.defaultModules
        self.nixosModules.a
      ];
    };

    homeConfigurations.frost_ice = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./main/default.nix
        (genUserConf { username = "frost_ice"; })
        self.homeModules
        self.defaultModules
      ];
      extraSpecialArgs = {
        system = "x86_64-linux";
        inherit inputs;
      };
    };
  };
}
