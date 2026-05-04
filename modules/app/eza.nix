{pkgs, ...}: {
  programs.eza = {
    enable = true;
    colors = "auto";
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--classify"
      "--sort=extension"
    ];
  };
}
