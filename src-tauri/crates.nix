{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    crateName = "app";

    libraries = with pkgs; [
      webkitgtk
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl_3
      librsvg
    ];

    packages = with pkgs; [
      curl
      wget
      pkg-config
      dbus
      openssl_3
      glib
      gtk3
      libsoup
      webkitgtk
      librsvg
    ];
    # packages = with pkgs; [
    #   # libclang
    #   # curl
    #   # wget
    #   # dbus
    #   # openssl
    #   # glib
    #   # libsoup
    #   # webkitgtk
    #   # librsvg
    #   libappindicator-gtk3
    #   cairo
    #   # llvmPackages.libclang
    # ];
    # libraries = with pkgs; [
    #   # webkitgtk
    #   # gdk-pixbuf
    #   # glib
    #   # dbus
    #   # librsvg
    #   # atk
    #   # gobject-introspection
    #   # gtk4
    # ];
  in {
    nci.projects.${crateName}.path = ./.;
    nci.crates = {
      ${crateName} = {
        # depsDrvConfig = {
        #   deps.stdenv = pkgs.clangStdenv;
        # };
        drvConfig = {
          # deps.stdenv = pkgs.clangStdenv;
          mkDerivation = {
            nativeBuildInputs = with pkgs; [pkg-config];
            buildInputs = packages;
            # LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib";
            shellHook = ''
              echo "Hello world, tauri with mkDerivation!"
              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
              export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
            '';
          };
        };
      };
    };

    # devShells.default = config.nci.outputs.${crateName}.devShell.overrideAttrs (old: let
    # in {
    # shellHook = ''
    #   ${old.shellHook or ""}
    #   echo "Hello world, tauri!"
    #   export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    #   export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
    # '';
    # });
  };
}
