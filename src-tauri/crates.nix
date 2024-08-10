{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    crateName = "tauri-app";
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
  in {
    nci.projects.${crateName}.path = ./.;
    nci.crates = {
      ${crateName} = {
        drvConfig = {
          mkDerivation = {
            buildInputs = packages;
            shellHook = ''
              echo "Hello world, tauri with mkDerivation!"
              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
              export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
            '';
          };
        };
      };
    };

    devShells.default = config.nci.outputs.${crateName}.devShell.overrideAttrs (old: let
    in {
      # shellHook = ''
      #   ${old.shellHook or ""}
      #   echo "Hello world, tauri!"
      #   export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
      #   export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
      # '';
    });
  };
}
