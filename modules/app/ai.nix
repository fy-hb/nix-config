{ config, ... }:
{
  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
    CODEX_HOME = "${config.xdg.configHome}/codex";
    # 怎么是相对路径？
    PI_CONFIG_DIR = ".config/omp";
  };
}
