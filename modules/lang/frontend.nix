{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typescript
    nodejs_24
    corepack_24
    eslint
    bun
  ];
  home.sessionVariables = {
    NODE_REPL_HISTORY = "$HOME/.config/node/node_repl_history";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    NPM_CONFIG_PREFIX = "$HOME/.local/share/npm";
    NPM_CONFIG_CACHE = "$HOME/.cache/npm";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };
}
