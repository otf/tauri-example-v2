{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    crateName = "tauri-app";

    nativeBuildPackages = with pkgs; [
      pkg-config
      dbus
      openssl
      glib
      gtk3
      libsoup
      webkitgtk
      librsvg
    ];

    libraries = with pkgs; [
      webkitgtk
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl
      librsvg
    ];

    packages = with pkgs; [
      curl
      wget
      dbus
      openssl_3
      glib
      gtk3
      libsoup
      webkitgtk
      librsvg
    ];
  in {
    nci.projects.${crateName}.path = ./.;
    nci.crates = {
      ${crateName} = rec {
        depsDrvConfig = {
          mkDerivation = {
            nativeBuildInputs = nativeBuildPackages;
            buildInputs = packages;
          };
        };
        drvConfig = {
          inherit (depsDrvConfig) mkDerivation;
        };
      };
    };
  };
}
