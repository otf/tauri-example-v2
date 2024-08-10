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
    nci.toolchainConfig = ./rust-toolchain.toml;
    nci.crates = {
      ${crateName} = {
        # depsDrvConfig = {
        #   deps.stdenv = pkgs.clangStdenv;
        # };
        drvConfig = {
          # deps.stdenv = pkgs.clangStdenv;
          mkDerivation = {
            nativeBuildInputs = nativeBuildPackages;
            buildInputs = packages;
            # LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib";
            shellHook = with pkgs; ''
              echo "Hello world, tauri with mkDerivation!"
              # export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS

              export LD_LIBRARY_PATH="${
                lib.makeLibraryPath libraries
              }:$LD_LIBRARY_PATH"
              export OPENSSL_INCLUDE_DIR="${openssl.dev}/include/openssl"
              export OPENSSL_LIB_DIR="${openssl.out}/lib"
              export OPENSSL_ROOT_DIR="${openssl.out}"
              export RUST_SRC_PATH="${config.nci.toolchains.shell}/lib/rustlib/src/rust/library"
            '';

            buildPhase = ''
              cargo tauri build -b none
            '';
            # dontInstall = true;
          };
        };
      };
    };
  };
}
