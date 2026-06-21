{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    hmcl
  ];
  home.sessionVariables = {
    HMCL_USER_HOME = "${config.xdg.dataHome}/hmcl/user";
    HMCL_LOCAL_HOME = "${config.xdg.dataHome}/hmcl/local";
    HMCL_DEPENDENDPENDENCIES_DIR = "${config.xdg.dataHome}/hmcl/dep";
  };
}
