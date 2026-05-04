 {pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    signing.format = "openpgp";
    settings = {
      user.signingkey="58F0009E76DB637F";
      user.email="fyhb233@gmail.com";
      user.name="F. ICE";
      commit.gpgsign=true;
      diff.tool = "vscode";
      difftool.vscode.cmd = "code --wait --diff \"\$LOCAL\" \"$REMOTE\"";
      merge.tool = "vscode";
      mergetool.vscode.cmd = "code --wait \$MERGED";
      remote.origin.partialclonefilter = "blob:limit=1m";
    };
  };
}

