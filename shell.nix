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
    # // alias setup="cmake -GNinja . ${toString CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=RelWithDebInfo"
    alias setup_debug="cmake -GNinja . ${toString CMAKE_FLAGS}  -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS='-gsplit-dwarf -fno-lto' -DCMAKE_C_FLAGS='-gsplit-dwarf -fno-lto' -DCMAKE_EXE_LINKER_FLAGS='-fuse-ld=mold'"
    alias setup="cmake -GNinja . ${toString CMAKE_FLAGS} -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS_RELEASE='-O0 -gsplit-dwarf -fno-lto' -DCMAKE_C_FLAGS_RELEASE='-O0 -gsplit-dwarf -fno-lto' -DCMAKE_EXE_LINKER_FLAGS='-fuse-ld=mold'
"
    setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
    echo "shellHook: setQtEnvironment = $setQtEnvironment"
    makeWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
    sed "/^exec/d" -i "$setQtEnvironment"
    source "$setQtEnvironment"
  '';

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    abseil-cpp.out
    openssl
    openh264
    glib
    xorg.libxcb
    xorg.libX11
    xorg.libXext
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXdamage
    xorg.xcbutilkeysyms
    xorg.libXtst
    xorg.libXrandr
    crc32c

    libjpeg
    zlib
    libsForQt5.full
    libvpx
    pipewire
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
    libgcc.lib
  ];

  nativeBuildInputs = [
    # libgcc.lib
    mold
    pkg-config
    cmake
    ninja
    python3
    clang
    gobject-introspection
  ];
}
