{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    crateName = "app";
    packages = with pkgs; [
      at-spi2-atk
      atkmm
      cairo
      gdk-pixbuf
      glib
      gobject-introspection
      gobject-introspection.dev
      gtk3
      harfbuzz
      librsvg
      libsoup_3
      pango
      webkitgtk_4_1
      webkitgtk_4_1.dev
      openssl_3
    ];
    libraries = with pkgs; [
      pkg-config
      glib.dev
      libsoup_3.dev
      webkitgtk_4_1.dev
      at-spi2-atk.dev
      gtk3.dev
      gdk-pixbuf.dev
      cairo.dev
      pango.dev
      harfbuzz.dev
    ];
  in {
    nci.projects.${crateName}.path = ./.;
    nci.crates = {
      ${crateName} = rec {
        depsDrvConfig = {
          mkDerivation = {
            buildInputs = packages;
            nativeBuildInputs = libraries;
          };
        };
        drvConfig = {
          inherit (depsDrvConfig) mkDerivation;
        };
      };
    };
  };
}
