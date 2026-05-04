{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ghc
  ];
  home.sessionVariables = {
  };
}
