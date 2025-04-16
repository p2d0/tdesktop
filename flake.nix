{
  description = "kek";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    # libtgvoip = {
    #   url = "https://github.com/telegramdesktop/libtgvoip";
    #   flake = false;
    # };

    # GSL = {
    #   url = "https://github.com/Microsoft/GSL.git";
    #   flake = false;
    # };

    # xxHash = {
    #   url = "https://github.com/Cyan4973/xxHash.git";
    #   flake = false;
    # };

    # rlottie = {
    #   url = "https://github.com/desktop-app/rlottie.git";
    #   flake = false;
    # };

    # lz4 = {
    #   url = "https://github.com/lz4/lz4.git";
    #   flake = false;
    # };

    # lib_crl = {
    #   url = "https://github.com/desktop-app/lib_crl.git";
    #   flake = false;
    # };

    # lib_rpl = {
    #   url = "https://github.com/desktop-app/lib_rpl.git";
    #   flake = false;
    # };

    # lib_base = {
    #   url = "https://github.com/desktop-app/lib_base.git";
    #   flake = false;
    # };

    # codegen = {
    #   url = "https://github.com/desktop-app/codegen.git";
    #   flake = false;
    # };

    # lib_ui = {
    #   url = "https://github.com/desktop-app/lib_ui.git";
    #   flake = false;
    # };

    # lib_lottie = {
    #   url = "https://github.com/desktop-app/lib_lottie.git";
    #   flake = false;
    # };

    # lib_tl = {
    #   url = "https://github.com/desktop-app/lib_tl.git";
    #   flake = false;
    # };

    # lib_spellcheck = {
    #   url = "https://github.com/desktop-app/lib_spellcheck";
    #   flake = false;
    # };

    # lib_storage = {
    #   url = "https://github.com/desktop-app/lib_storage.git";
    #   flake = false;
    # };

    # cmake = {
    #   url = "https://github.com/desktop-app/cmake_helpers.git";
    #   flake = false;
    # };

    # expected = {
    #   url = "https://github.com/TartanLlama/expected";
    #   flake = false;
    # };

    # QR = {
    #   url = "https://github.com/nayuki/QR-Code-generator";
    #   flake = false;
    # };

    # lib_qr = {
    #   url = "https://github.com/desktop-app/lib_qr.git";
    #   flake = false;
    # };

    # hunspell = {
    #   url = "https://github.com/hunspell/hunspell";
    #   flake = false;
    # };

    # range-v3 = {
    #   url = "https://github.com/ericniebler/range-v3.git";
    #   flake = false;
    # };

    # nimf = {
    #   url = "https://github.com/hamonikr/nimf.git";
    #   flake = false;
    # };

    # hime = {
    #   url = "https://github.com/hime-ime/hime.git";
    #   flake = false;
    # };

    # fcitx5-qt = {
    #   url = "https://github.com/fcitx/fcitx5-qt.git";
    #   flake = false;
    # };

    # lib_webrtc = {
    #   url = "https://github.com/desktop-app/lib_webrtc.git";
    #   flake = false;
    # };

    # tgcalls = {
    #   url = "https://github.com/TelegramMessenger/tgcalls.git";
    #   flake = false;
    # };

    # lib_webview = {
    #   url = "https://github.com/desktop-app/lib_webview.git";
    #   flake = false;
    # };

    # jemalloc = {
    #   url = "https://github.com/jemalloc/jemalloc";
    #   flake = false;
    # };

    # dispatch = {
    #   url = "https://github.com/apple/swift-corelibs-libdispatch";
    #   flake = false;
    # };

    # kimageformats = {
    #   url = "https://github.com/KDE/kimageformats.git";
    #   flake = false;
    # };

    # kcoreaddons = {
    #   url = "https://github.com/KDE/kcoreaddons.git";
    #   flake = false;
    # };

    # cld3 = {
    #   url = "https://github.com/google/cld3.git";
    #   flake = false;
    # };

    # libprisma = {
    #   url = "https://github.com/desktop-app/libprisma.git";
    #   flake = false;
    # };

    # xdg-desktop-portal = {
    #   url = "https://github.com/flatpak/xdg-desktop-portal.git";
    #   flake = false;
    # };
  };

  outputs = inputs @ { self, nixpkgs, devshell, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        inherit (nixpkgs) lib;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowBroken = true;
          overlays = [
            devshell.overlays.default
            # self.overlay
          ];
        };
      in
        {
          inherit self;
          packages = {
            default = (pkgs.callPackage ./tdesktop.nix {inherit self;});
          };

          devShell = import ./shell.nix { inherit pkgs; };
        }
    );
}
