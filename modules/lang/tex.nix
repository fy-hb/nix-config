{ config, pkgs, ... }:
{
  #   programs.texlive = {
  #     enable = true;
  #     package = pkgs.;
  #   };
  home.sessionVariables = {
    TEXMFCONFIG = "${config.xdg.configHome}/texlive";
    TEXMFVAR = "${config.xdg.cacheHome}/texlive";
    TEXMFHOME = "${config.xdg.dataHome}/texmf";
  };
  home.packages = with pkgs; [
    texliveFull
    texstudio
    hunspell
  ];
}
