{ lib, ... }:
let
  currentPath = ./.;
  toOption = { prefix, name, func }: args@{ config, lib, pkgs, ... }:
  let
    prefixList = lib.splitString "." prefix;
    fullPath = prefixList ++ [ name ];
    cfg = lib.attrByPath fullPath {} config;
  in
  {
    config = lib.mkIf (cfg.enable or false) (func args);
    options = lib.setAttrByPath fullPath {
      enable = lib.mkOption {
        default = false;
        example = true;
        description = "Whether to enable ${name}.";
        type = lib.types.bool;
      };
    };
  };
  loadModule = moduleName: prefix:
  let
    _basedir = currentPath + "/${moduleName}";
    _allfiles = builtins.readDir _basedir;
    _modulefiles = lib.filterAttrs (filename: type: type == "directory" || (type == "regular" && lib.hasSuffix ".nix" filename)) _allfiles;
    _modulenames = lib.mapAttrsToList (name: _ : name) _modulefiles;
    modules = map (name: toOption { inherit prefix; name = ((lib.removeSuffix ".nix") name); func=import (_basedir + "/${name}"); }) _modulenames;
  in
    modules;
in
{
  config.flake.mymodules = {
    app = _ : { imports = loadModule "app" "my.app"; };
    lang = _ : { imports = loadModule "lang" "my.lang"; };
    sys = _ : { imports = loadModule "sys" "my.sys"; };
  };
}
