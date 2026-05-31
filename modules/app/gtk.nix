{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    gtk2 = {
      enable = true;
    };
  };
}
