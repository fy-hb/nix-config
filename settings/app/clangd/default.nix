{ pkgs, config, lib, ... }:

{
  home.file = {
    ".config/clangd/config.yaml".source = ./. + "/config.yaml";
  };
}
