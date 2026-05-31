{ config, pkgs, ... }:
let
  configPath = "${config.xdg.configHome}/wget/wgetrc";
in
{
  home.sessionVariables = {
    WGETRC = configPath;
  };
  home.packages = with pkgs; [ wget ];
  home.file."${configPath}".text = ''
    hsts-file = ${config.xdg.stateHome}/wget/hsts
  '';
}
