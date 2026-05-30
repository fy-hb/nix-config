 { pkgs, config, ...}:
 {
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
#   home.sessionVariables = {
#     GNUPGHOME = "$HOME/.local/share/gnupg";
#   };
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-all;
  };
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      gui = {
        nerdFontsVersion = "3";
        customIcons.extensions = {
          ".http" = {
            icon = "󰌷";
            color = "#f7a182";
          };
        };
      };
      git.pagers = [
        {
          pager = "delta --dark --paging=never";
          colorArg = "always";
        }
      ];
      git.overrideGpg = true;
      customCommands = [
        {
          key = "P";
          loadingText = "pushing";
          context = "remoteBranches";
          description = "Push to remote branch";
          prompts = [
            {
              type = "menu";
              title = "How to push?";
              options = [
                { value = "push"; }
                { value = "push --force-with-lease"; }
                { value = "push --force"; }
              ];
            }
          ];
          command = "git {{index .PromptResponses 0}} {{.SelectedRemote.Name}} {{.SelectedRemoteBranch.Name}}";
        }
        {
          key = "p";
          loadingText = "pulling";
          context = "remoteBranches";
          description = "Pull from remote branch";
          command = "git pull {{.SelectedRemote.Name}} {{.SelectedRemoteBranch.Name}}";
        }
      ];
    };
  };
}

