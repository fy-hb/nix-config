{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    wineWow64Packages.stable
    wineWow64Packages.fonts
    winetricks
  ];
  home.sessionVariables = {
    WINEPREFIX = "${config.xdg.dataHome}/wine";
  };
}
