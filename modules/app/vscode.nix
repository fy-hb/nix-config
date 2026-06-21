{ config, pkgs, lib, ... }:
let
  home = config.home.homeDirectory;
  dataRoot = "${config.xdg.dataHome}/vscode";
  binds = [
    { src = dataRoot; dst = ".vscode";        kind = "dir"; }
    { src = dataRoot; dst = ".vscode-shared"; kind = "dir"; }
    { src = "${dataRoot}/dotdotdotdotdotdotnet"; dst = ".dotnet"; kind = "dir"; }
  ];

  # 这些 basename 让位给上面的 --bind，不参与回挂；按 dst 生成。
  skipPattern = lib.concatMapStringsSep "|" (b: b.dst) binds;

  preBwrap = ''
    # 1) 确保宿主源路径存在；--bind 不存在的源会报错。
    ${lib.concatMapStringsSep "\n" (b:
      if b.kind == "dir"
      then ''mkdir -p ${lib.escapeShellArg b.src}''
      else ''mkdir -p "$(dirname ${lib.escapeShellArg b.src})" && { [ -e ${lib.escapeShellArg b.src} ] || : > ${lib.escapeShellArg b.src}; }''
    ) binds}

    # 2) 用 FD 10 注入 bwrap 动态参数（NUL 分隔）：
    #    a. --tmpfs $HOME 盖住命名空间内的真实 $HOME，让后续 mkdir 落到 tmpfs。
    #    b. for 循环把真实 $HOME 的其它条目逐个 --bind 回 tmpfs。
    #    c. 末尾再 --bind 数据落点到 $HOME/<dst>，挂载点落在 tmpfs，无泄漏。
    exec 10< <(
      printf -- '--tmpfs\0%s\0' ${lib.escapeShellArg home}
      shopt -s nullglob dotglob
      for entry in ${lib.escapeShellArg home}/*; do
        base="''${entry##*/}"
        case "$base" in
          ${skipPattern}) continue ;;
        esac
        printf -- '--bind\0%s\0%s\0' "$entry" "$entry"
      done
      ${lib.concatMapStringsSep "\n" (b:
        ''printf -- '--bind\0%s\0%s\0' ${lib.escapeShellArg b.src} ${lib.escapeShellArg (home + "/" + b.dst)}''
      ) binds}
    )
  '';

  # generic.nix 暴露 customizeFHSEnv 钩子，但 pkgs.vscode 顶层（vscode.nix）
  # 没把它转发出来。这里用局部 overlay 包装 buildVscode：所有用它构造的
  # vscode 系列包都会带上我们的 customizeFHSEnv，pkgs.vscode.fhs 即生效。
  pkgs' = pkgs.extend (final: prev: {
    buildVscode = args: prev.buildVscode (args // {
      customizeFHSEnv = fhsArgs: fhsArgs // {
        extraPreBwrapCmds = (fhsArgs.extraPreBwrapCmds or "") + "\n" + preBwrap;
        extraBwrapArgs = (fhsArgs.extraBwrapArgs or []) ++ [ "--args" "10" ];
      };
    });
  });
in
{
  home.packages = [ pkgs'.vscode.fhs ];
  home.file.".config/code-flags.conf".text = ''
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-wayland-ime
    --wayland-text-input-version=3
    --use-angle=vulkan
    --use-cmd-decoder=passthrough
    --disable-gpu-memory-buffer-video-frames
  '';
}
