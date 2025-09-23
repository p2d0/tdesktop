{ pkgs ? import <nixpkgs> {} }:

with pkgs;
with qt5;
mkShell rec {
  buildInputs = [
    qtbase
    qtimageformats
    gdb
    qtsvg
    lz4
    xxHash
    ffmpeg_6
    libsForQt5.wrapQtAppsHook
    makeWrapper
    openalSoft
    minizip
    libopus
    range-v3
    tl-expected
    rnnoise
    (callPackage ./tg_owt.nix {})
    microsoft-gsl
    boost
    ada
    protobuf
    qtwayland
    kdePackages.kcoreaddons
    alsa-lib
    libpulseaudio
    hunspell
    jemalloc
  ];
  CONFIG="Debug";

  CMAKE_FLAGS = [
    # We're allowed to used the API ID of the Snap package:
    (lib.cmakeFeature "TDESKTOP_API_ID" "1870832")
    (lib.cmakeFeature "TDESKTOP_API_HASH" "1cff50b12b773b08f0dd40d11d5a530f")
  ];

  shellHook = ''
    alias setup="cmake -GNinja . ${toString CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=RelWithDebInfo"
    setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
    echo "shellHook: setQtEnvironment = $setQtEnvironment"
    makeWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
    sed "/^exec/d" -i "$setQtEnvironment"
    source "$setQtEnvironment"
  '';

  nativeBuildInputs = [
      pkg-config
      cmake
      ninja
      python3
      clang
      gobject-introspection
  ];
}
