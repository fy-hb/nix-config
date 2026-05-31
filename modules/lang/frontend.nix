{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    typescript
    nodejs_24
    corepack_24
    eslint
  ];
  home.sessionVariables = {
    NODE_REPL_HISTORY = "${config.xdg.configHome}/node/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NPM_CONFIG_PREFIX = "${config.xdg.dataHome}/npm";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    PNPM_HOME = "${config.xdg.dataHome}/pnpm";
  };
  home.sessionPath = [
    "${config.xdg.dataHome}/pnpm/bin"
    "${config.xdg.cacheHome}/.bun/bin"
    "${config.xdg.dataHome}/npm/bin/"
  ];
}
