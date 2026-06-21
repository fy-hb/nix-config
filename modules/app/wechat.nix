{ config, pkgs, lib, ... }:
let
  # 把 wechat 进程视图里的这几个 $HOME 路径重定向到 XDG_DATA_HOME 下，
  # 真实 $HOME 不会被污染。bwrap 不展开 $HOME，必须用字面绝对路径。
  home = config.home.homeDirectory;
  dataRoot = "${config.xdg.dataHome}/wechat-mounts";
  binds = [
    { src = "${dataRoot}/xwechat_files"; dst = "${home}/xwechat_files"; kind = "dir"; }
    { src = "${dataRoot}/dotxwechat";    dst = "${home}/.xwechat";      kind = "dir"; }
    { src = "${dataRoot}/sys1og.conf";   dst = "${home}/.sys1og.conf";  kind = "file"; }
  ];

  # 在进入 bwrap 之前确保宿主源路径存在；--bind 不存在的源会报错。
  preBwrap = lib.concatStringsSep "\n" (map (b:
    if b.kind == "dir"
    then ''mkdir -p "${b.src}"''
    else ''mkdir -p "$(dirname "${b.src}")"; [ -e "${b.src}" ] || : > "${b.src}"''
  ) binds);

  # 追加到 bwrap 命令行末尾；位于自动 /home 绑定之后，因此覆盖之。
  extraBwrap = lib.concatMap (b: [ "--bind" b.src b.dst ]) binds;

  # package.nix 顶层不暴露 appimageTools；wechat 内部经 callPackage 自动注入。
  # 通过 pkgs.extend 建一个局部 overlay 视图，仅给 wechat 看到改造过的
  # wrapAppImage —— 全局 pkgs 与其它 appimage 包不受影响。
  pkgs' = pkgs.extend (final: prev: {
    appimageTools = prev.appimageTools // {
      wrapAppImage = args: prev.appimageTools.wrapAppImage (args // {
        extraPreBwrapCmds = (args.extraPreBwrapCmds or "") + "\n" + preBwrap;
        extraBwrapArgs = (args.extraBwrapArgs or []) ++ extraBwrap;
      });
    };
  });
in
{
  home.packages = [ pkgs'.wechat ];
}
