{ pkgs, config, ... }:
{
  home.file.".config/code-flags.conf".text = ''
    --ozone-platform-hint=wayland
    --gtk-version=4
    --ignore-gpu-blocklist
    --enable-wayland-ime
    --wayland-text-input-version=3
    --use-angle=vulkan
    --use-cmd-decoder=passthrough
    --disable-gpu-memory-buffer-video-frames
    --user-data-dir="${config.xdg.dataHome}/vscode/user"
    --extensions-dir="${config.xdg.dataHome}/vscode/extensions"
  '';
}
