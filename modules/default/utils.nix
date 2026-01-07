{ config, lib, ... }:
let
  username = "frost_ice";
  server = false;
  homePath = if config ? home then config.home.homeDirectory else config.users.users.${username}.home;
  genPath = lib.concatStringsSep ":";

  genUtils = utilsAttrs: {
    options = builtins.mapAttrs (
      _: value:
      lib.mkOption {
        type = lib.types.anything;
        default = value;
      }
    ) utilsAttrs;
  };
in
genUtils {
  inherit genPath username homePath server;
}
