{
  pkgs,
  config,
  lib,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  uvBuilder =
    name:
    pkgs.buildFHSEnv {
      inherit name;
      runScript = name;
      targetPkgs =
        pkgs: with pkgs; [
          uv
          zlib
          stdenv.cc.cc
        ];
    };
  pyWrapper =
    py: alias:
    pkgs.runCommand "python-wrappers"
      {
        buildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        for name in ${lib.concatStringsSep " " alias}; do
          makeWrapper ${py}/bin/python $out/bin/$name \
            --set LD_LIBRARY_PATH "$NIX_LD_LIBRARY_PATH"
        done
      '';
  uvFHS = uvBuilder "uv";
  uvxFHS = uvBuilder "uvx";
in
{
  home.sessionVariables = {
    PIXI_HOME = "${config.xdg.dataHome}/pixi";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    PYTHONHISTFILE = "${config.xdg.stateHome}/python/history";
  };
  home.packages =
    if isDarwin then
      with pkgs;
      [
        python
        python313
        uv
        python313Packages.pip
      ]
    else
      [
        (pyWrapper pkgs.python313 [
          "py"
          "python"
          "python3"
          "python313"
        ])
        uvFHS
        uvxFHS
      ];
}
