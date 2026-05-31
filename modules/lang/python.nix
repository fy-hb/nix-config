{ pkgs, config, ... }:
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
  python3_13 = pkgs.writeShellScriptBin "python" ''
    export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    exec ${pkgs.python313}/bin/python "$@"
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
        python313
        uv
        python313Packages.pip
      ]
    else
      [
        python3_13
        uvFHS
        uvxFHS
      ];
}
