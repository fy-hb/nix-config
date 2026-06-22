{ inputs, system, ... }:
let
  # nixpkgs overlays
  overlays = with inputs; [

    nh.overlays.default
    (final: prev: {
      nix-output-monitor = prev.nix-output-monitor.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          # Your patching commands go here
          substituteInPlace lib/NOM/Update/Monad.hs \
            --replace-fail "import Data.Text.IO" "import Data.Text.IO.Utf8"
        '';
      });
    })
    (final: prev: {
      clash-verge-rev = nixpkgs-clash-verge-rev.legacyPackages."${system}".clash-verge-rev;
    })
  ];
in
{
  nixpkgs = {
    inherit overlays system;
    config.allowUnfree = true;
  };
}
