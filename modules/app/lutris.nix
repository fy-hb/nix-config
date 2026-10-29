{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  programs.lutris = {
    enable = true;
    protonPackages = with pkgs; [
      dwproton-bin
    ];
    steamPackage = osConfig.programs.steam.package;
  };
}
