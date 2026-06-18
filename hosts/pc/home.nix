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
      wechat
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

      NODE_REPL_HISTORY = "${config.xdg.configHome}/node/node_repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      NPM_CONFIG_PREFIX = "${config.xdg.dataHome}/npm";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      PNPM_HOME = "${config.xdg.dataHome}/pnpm";

      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";

      GPG_TTY = "$(tty)";
      DOCKER_CONFIG = "${config.xdg.configHome}/docker";

      DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
      DOTNET_ROOT = "${config.xdg.dataHome}/dotnet";

      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";

      NUGET_PACKAGES = "${config.xdg.dataHome}/NuGet/packages";

      CONDARC = "${config.xdg.configHome}/conda/condarc";

      HISTFILE = "${config.xdg.dataHome}/sh-histfile";

      NSS_DEFAULT_DB_DIR = "${config.xdg.dataHome}/pki/nssdb";
      NSS_DEFAULT_DB_TYPE = "sql";
      SSL_DIR = "${config.xdg.dataHome}/pki/nssdb";
      HOME_NSS_DB_PATH = "${config.xdg.dataHome}/pki/nssdb";

      CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv/ComputeCache";

      ANDROID_SDK_HOME = "${config.xdg.dataHome}/android";
    };
    sessionPath = [
      "${config.xdg.binHome}"
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
    wget.enable = true;
    gtk.enable = true;
    wine.enable = true;
  };
  my.lang = {
    python.enable = true;
    frontend.enable = true;
    rust.enable = true;
    tex.enable = true;
  };
  programs.man.generateCaches = false;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  xdg.enable = true;
}
