{pkgs, lib, ...}:
let
  exifaudio = pkgs.fetchFromGitHub {
    owner = "Sonico98";
    repo = "exifaudio.yazi";
    rev = "4506f9d";
    sha256 = "sha256-RWCqWBpbmU3sh/A+LBJPXL/AY292blKb/zZXGvIA5/o=";
  };
in
{
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableFishIntegration = true;
    shellWrapperName = "y";
    settings = lib.importTOML ./yazi.toml;
    theme = lib.importTOML ./theme.toml;
    keymap = lib.importTOML ./keymap.toml;
    initLua = ./init.lua;
    plugins = with pkgs; {
#       inherit exifaudio;
      starship = yaziPlugins.starship;
      git = yaziPlugins.git;
      smart-enter = yaziPlugins.smart-enter;
      toggle-pane = yaziPlugins.toggle-pane;
#       folder-rules = ./. + "/plugins/folder-rules.yazi";
    };
  };
}
