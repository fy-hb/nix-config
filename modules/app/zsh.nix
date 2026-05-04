{ config, pkgs, ... }: {
  home.shell.enableZshIntegration = false;
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
  };
}
