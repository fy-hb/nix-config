{ config, pkgs, lib, ... }:
let
  home = config.home.homeDirectory;
  dataRoot = "${config.xdg.dataHome}/wechat-mounts";

  # 三条 wechat 数据重定向；dst 是 wechat 视角下的路径（$HOME 下），src 是真实落地处。
  binds = [
    { src = "${dataRoot}/xwechat_files"; dst = "xwechat_files"; kind = "dir"; }
    { src = "${dataRoot}/dotxwechat";    dst = ".xwechat";      kind = "dir"; }
    { src = "${dataRoot}/sys1og.conf";   dst = ".sys1og.conf";  kind = "file"; }
  ];

  # 这些 basename 让位给上面三条 --bind，不参与回挂。
  skipPattern = lib.concatMapStringsSep "|" (x : x.dst) binds;

  preBwrap = ''
    # 1) 确保宿主源路径存在；--bind 不存在的源会报错。
    ${lib.concatMapStringsSep "\n" (b:
      if b.kind == "dir"
      then ''mkdir -p ${lib.escapeShellArg b.src}''
      else ''mkdir -p "$(dirname ${lib.escapeShellArg b.src})" && { [ -e ${lib.escapeShellArg b.src} ] || : > ${lib.escapeShellArg b.src}; }''
    ) binds}

    # 2) 用 FD 10 注入 bwrap 动态参数（NUL 分隔）：
    #    a. --tmpfs $HOME 在命名空间内盖住真实 $HOME，让后续 bwrap mkdir
    #       落到 tmpfs，避免空挂载点漏到宿主。
    #    b. for 循环把真实 $HOME 的其它条目逐个 --bind 回 tmpfs，
    #       wechat 仍能读到 .config/.cache 等。
    #    c. 末三条 --bind 把数据落点重定向到 dataRoot。
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

  pkgs' = pkgs.extend (final: prev: {
    appimageTools = prev.appimageTools // {
      wrapAppImage = args: prev.appimageTools.wrapAppImage (args // {
        extraPreBwrapCmds = (args.extraPreBwrapCmds or "") + "\n" + preBwrap;
        extraBwrapArgs = (args.extraBwrapArgs or []) ++ [ "--args" "10" ];
      });
    };
  });
in
{
  home.packages = [ pkgs'.wechat ];
}
