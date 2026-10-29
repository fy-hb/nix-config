{
  inputs = {
    nixpkgs.url = "git+ssh://git@github.com/nixos/nixpkgs?ref=nixos-unstable&shallow=1";
    home-manager = {
      url = "git+ssh://git@github.com/nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "git+ssh://git@github.com/Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "git+ssh://git@github.com/nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "git+ssh://git@github.com/nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "git+ssh://git@github.com/nix-community/nixGL";
    flake-parts.url = "git+ssh://git@github.com/hercules-ci/flake-parts";
    impermanence.url = "git+ssh://git@github.com/nix-community/impermanence";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];
      imports = [
        ./modules
        ./hosts
      ];
    };
}
