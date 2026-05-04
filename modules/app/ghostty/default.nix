{ pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  special =
    if isDarwin then {
      font-size = 18.5;
      window-height = 38;
      window-width = 154;
      window-padding-y = "1,1";
      macos-option-as-alt = true;
      macos-titlebar-style = "tabs";
      macos-icon = "custom-style";
      macos-icon-ghost-color = "mistyrose";
      macos-titlebar-proxy-icon = "visible";
      macos-icon-screen-color = "blue";
      keybind = [
        "super+enter=unbind"
        "option+left=unbind"
        "option+right=unbind"
        "ctrl+v=paste_from_clipboard"
        "command+q=text:\\x1b[113;3u" # send Alt + q with escape sequence
        "ctrl+shift+apostrophe=new_split:right"
        "ctrl+shift+semicolon=new_split:down"
      ];
      theme = "dark:Everforest,light:Gruvbox Light Hard";
    } else {
      font-size = 14;
      theme = "Everforest";
      window-height = 40;
      window-width = 135;
      gtk-titlebar = false;
      window-decoration = "none";
      gtk-titlebar-style = "tabs";
#       gtk-titlebar-hide-when-maximized = true;
      keybind = [
          "ctrl+enter=unbind"
          "ctrl+v=paste_from_clipboard"
          "ctrl+shift+v=text:\\x16"
          "ctrl+shift+apostrophe=new_split:right"
          "ctrl+shift+semicolon=new_split:down"
      ];
      font-family = [
        "JetBrainsMonoNL NF"
        "LXGW WenKai"
      ];
      cursor-style = "block";
      confirm-close-surface = false;
      shell-integration-features = "no-cursor";
      window-title-font-family = "LXGW WenKai";
    };
  settings = special // {
    font-family = [
      "JetBrainsMonoNL Nerd Font"
      "LXGW WenKai"
    ];
    cursor-style = "block";
    confirm-close-surface = false;
    shell-integration-features = "no-cursor";
    window-title-font-family = "JetBrainsMonoNL Nerd Font";
  };
in
{
  programs.ghostty = {
    enable = true;
    systemd.enable = false;
    package = null;
    themes.Everforest = {
      background = "#272E33";
      foreground = "#d3c6aa";
      cursor-color = "#e69875";
      cursor-text = "#4c3743";
      palette = [
        "0=#7a8478"
        "1=#e67e80"
        "2=#a7c080"
        "3=#dbbc7f"
        "4=#7fbbb3"
        "5=#d699b6"
        "6=#83c092"
        "7=#f2efdf"
        "8=#a6b0a0"
        "9=#f85552"
        "10=#8da101"
        "11=#dfa000"
        "12=#3a94c5"
        "13=#df69ba"
        "14=#35a77c"
        "15=#fffbef"
      ];
      selection-background = "#4c3743";
      selection-foreground = "#d3c6aa";
    };
    enableFishIntegration = true;
    inherit settings;
  };
}
