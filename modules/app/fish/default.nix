{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellAliases = {
      v = "nvim";
      vi = "nvim";
      lg = "lazygit";
      fa = "fastfetch";
      cls = "clear";
      py = "python";
      ls = "eza --icons --group-directories-first --sort=extension -F";
      vf = "set -l file (fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'); and test -n \"\$file\"; and vi \"\$file\"";
      zf = "z \$(fd --type d --hidden . 2>/dev/null | fzf)";
      gg = "rg --max-columns=150 --max-columns-preview --colors=line:none --colors=line:style:bold -S";
    };

    functions = {
      mk = {
        body = ''
          set base $argv[1]
          set flags $argv[2..-1]
          g++ $base.cpp -o $base $flags
        '';
      };
      __fish_command_not_found_handler = {
        body = "__fish_default_command_not_found_handler $argv[1]";
        onEvent = "fish_command_not_found";
      };
      __fish_list_current_token = {
        body = ''
          set -l val (commandline -t | string replace -r '^~' "$HOME")
          printf "\n"
          if test -d $val
              ls -a $val
          else
              set -l dir (dirname -- $val)
              if test $dir != . -a -d $dir
                  ls -a $dir
              else
                  ls -a
              end
          end

          string repeat -N \n --count=(math (count (fish_prompt)) - 1)

          commandline -f repaint
        '';
      };
    };
    interactiveShellInit = builtins.readFile ./config.fish;
  };
}
