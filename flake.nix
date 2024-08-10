{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nci = {
      url = "github:yusdacra/nix-cargo-integration";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dream2nix.follows = "dream2nix";
    };
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.nci.flakeModule
        ./src-tauri/crates.nix
      ];
      systems = import inputs.systems;
      perSystem = {
        config,
        pkgs,
        ...
      }: let
        crateOutputs = config.nci.outputs.app;
      in {
        devShells.default = crateOutputs.devShell.overrideAttrs (
          old:
            with pkgs; {
              packages = (old.packages or []) ++ [cargo-tauri];
            }
        );
        # in {
        # packages.default = crateOutputs.packages.release;
      };
      flake = {
        # The usual flake attributes can be defined here.
      };
    };
}
