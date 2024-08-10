{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    crateName = "tauri-app";
  in {
    nci.projects.${crateName}.path = ./.;
    nci.crates.${crateName} = {};
  };
}
