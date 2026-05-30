{ config, pkgs, ... }:
{
  home = {
    homeDirectory = "/home/${config.username}";
    username = config.username;
    stateVersion = "24.11";
    packages = with pkgs; [
      kdePackages.ark
      nh
      lazygit
      lazydocker
      nix-init
      nil
      nixfmt
      eza
      fzf
      ripgrep
      fd
      bat
      gnupg
      dust
      shell-gpt
      kaggle
      primesieve
      hmcl
      msedit
      delta
      rclone
      gh
      protonplus
      vscode
    ];
    sessionVariables = {
      EDITOR = "nvim";
      ICPC_FONT = "WenQuanYi Micro Hei";
      QT_SELECT = 5;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      #LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:/run/opengl-driver/lib";
      #MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
      #WAYLAND_DISPLAY = "wayland-0";
      #XDG_SESSION_TYPE = "wayland";

      FZF_DEFAULT_COMMAND = "fd -H -I -E '{.astro,.git,.kube,.idea,.vscode,.sass-cache,node_modules,build,.vscode-server,.virtualenvs,target}' --type f --strip-cwd-prefix";
      FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --color=bg+:,bg:,gutter:-1,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8";

      PYTHON_HISTORY = "$HOME/.config/python/python_history";

      NODE_REPL_HISTORY = "$HOME/.config/node/node_repl_history";
      NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
      NPM_CONFIG_PREFIX = "$HOME/.local/share/npm";
      NPM_CONFIG_CACHE = "$HOME/.cache/npm";
      PNPM_HOME = "$HOME/.local/share/pnpm";

      CARGO_HOME = "$HOME/.local/share/cargo";
      RUSTUP_HOME = "$HOME/.local/share/rustup";

      GPG_TTY = "$(tty)";
      DOCKER_CONFIG = "$HOME/.config/docker";

      DOTNET_CLI_HOME = "$HOME/.local/share/dotnet";

      GRADLE_USER_HOME = "$HOME/.local/share/gradle";

      NUGET_PACKAGES = "$HOME/.local/share/NuGet/packages";

      CONDARC = "$HOME/.config/conda/condarc";

      HISTFILE = "$HOME/.local/share/sh-histfile";

      NSS_DEFAULT_DB_DIR="$HOME/.local/share/pki/nssdb";

      ANDROID_SDK_HOME = "$HOME/.local/share/android";
    };
    sessionPath = [
      "$CARGO_HOME/bin"
      "$HOME/.local/bin"
    ];
  };
  my.app = {
    ai.enable = true;
    clangd.enable = true;
    kitty.enable = true;
    fish.enable = true;
    neovim.enable = true;
    sublime.enable = true;
    vscode.enable = true;
    wofi.enable = true;
    yazi.enable = true;
    git.enable = true;
    ripgrep.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    ghostty.enable = true;
    eza.enable = true;
    xdg.enable = true;
  };
  my.lang = {
    python.enable = true;
    frontend.enable = true;
    rust.enable = true;
  };
  programs.man.generateCaches = false;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  xdg.enable = true;
}
