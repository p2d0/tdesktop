{
  self,
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  pkg-config,
  cmake,
  ninja,
  clang,
  python3,
  tg_owt ? callPackage ./tg_owt.nix { inherit stdenv; },
  pkgs,
  lz4,
  xxHash,
  ffmpeg_6,
  protobuf,
  openalSoft,
  minizip,
  libopus,
  alsa-lib,
  libpulseaudio,
  range-v3,
  tl-expected,
  hunspell,
  gobject-introspection,
  jemalloc,
  rnnoise,
  microsoft-gsl,
  boost,
  ada,
  libicns,
  apple-sdk_15,
  nix-update-script,
}:

assert pkgs.lib.assertMsg ((self.submodules or true) == true)
  "Unable to build without submodules. Append '?submodules=1#' to the URI.";

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

# with import <nixpkgs> {};
# let
#   tg_owt = callPackage ./tg_owt.nix { inherit pkgs; };
# in
stdenv.mkDerivation (finalAttrs: {
  pname = "telegram-desktop-unwrapped";
  version = "5.13.1";

  src = self;

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioInputALSA.cpp \
      --replace-fail '"libasound.so.2"' '"${lib.getLib alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioOutputALSA.cpp \
      --replace-fail '"libasound.so.2"' '"${lib.getLib alsa-lib}/lib/libasound.so.2"'
    substituteInPlace Telegram/ThirdParty/libtgvoip/os/linux/AudioPulse.cpp \
      --replace-fail '"libpulse.so.0"' '"${lib.getLib libpulseaudio}/lib/libpulse.so.0"'
  '';

  nativeBuildInputs =
    [
      pkgs.libsForQt5.wrapQtAppsHook

      pkg-config
      cmake
      ninja
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # to build bundled libdispatch
      clang
      gobject-introspection
    ];

  buildInputs =
    [
      pkgs.qt5.qtbase
      pkgs.qt5.qtimageformats
      pkgs.qt5.qtsvg
      lz4
      xxHash
      ffmpeg_6
      openalSoft
      minizip
      libopus
      range-v3
      tl-expected
      rnnoise
      tg_owt
      microsoft-gsl
      boost
      ada


      protobuf
      pkgs.qt5.qtwayland
      pkgs.kdePackages.kcoreaddons
      alsa-lib
      libpulseaudio
      hunspell
      jemalloc
    ];

  # nativeBuildInputs =
  #   [
  #   ]
  #   ++ lib.optionals false [
  #     wrapGAppsHook3
  #   ];

  qtWrapperArgs = lib.optionals (stdenv.hostPlatform.isLinux && false) [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ pkgs.webkitgtk_4_1 ])
  ];

  # dontUnpack = true;
  dontWrapGApps = true;
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  cmakeFlags = [
    # We're allowed to used the API ID of the Snap package:
    # "--config Debug"
    # "-DCMAKE_BUILD_TYPE=Debug"
    (lib.cmakeFeature "TDESKTOP_API_ID" "1870832")
    (lib.cmakeFeature "TDESKTOP_API_HASH" "1cff50b12b773b08f0dd40d11d5a530f")
  ];
#   configurePhase = ''
# cmakeBuildType=Debug
# cmakeConfigurePhase '';

  # dontStrip = true;
  # cmakeBuildType = "Debug";
  # separateDebugInfo = true;
  # CONFIG="Debug";

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r ${finalAttrs.meta.mainProgram}.app $out/Applications
    ln -sr $out/{Applications/${finalAttrs.meta.mainProgram}.app/Contents/MacOS,bin}

    runHook postInstall
  '';

  preFixup = lib.optionalString (stdenv.hostPlatform.isLinux && false) ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    inherit tg_owt;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = if stdenv.hostPlatform.isLinux then "telegram-desktop" else "Telegram";
  };
})
