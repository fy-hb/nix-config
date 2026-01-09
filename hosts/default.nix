{ inputs, ... }:
let genUserConf = args :
  let
    username = args.username;
    server = args.server or false;
  in
    { lib, config, ... }: {
      options = {
        username = lib.mkOption { default = username; };
        homePath = lib.mkOption {
          default = if config ? home then config.home.homeDirectory else config.users.users.${config.username}.home;
        };
        server = lib.mkOption {
          default = server;
        };
      };
    };
in
{
  flake = with inputs; {
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
