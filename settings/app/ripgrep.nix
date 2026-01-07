{pkgs, ...} :
{
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };
}
