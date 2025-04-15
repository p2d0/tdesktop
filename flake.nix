{
  description = "kek";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    libtgvoip = {
      url = "git+file:./Telegram/ThirdParty/libtgvoip";
      flake = false;
    };

    GSL = {
      url = "git+file:./Telegram/ThirdParty/GSL";
      flake = false;
    };

    xxHash = {
      url = "git+file:./Telegram/ThirdParty/xxHash";
      flake = false;
    };

    rlottie = {
      url = "git+file:./Telegram/ThirdParty/rlottie";
      flake = false;
    };

    lz4 = {
      url = "git+file:./Telegram/ThirdParty/lz4";
      flake = false;
    };

    lib_crl = {
      url = "git+file:./Telegram/lib_crl";
      flake = false;
    };

    lib_rpl = {
      url = "git+file:./Telegram/lib_rpl";
      flake = false;
    };

    lib_base = {
      url = "git+file:./Telegram/lib_base";
      flake = false;
    };

    codegen = {
      url = "git+file:./Telegram/codegen";
      flake = false;
    };

    lib_ui = {
      url = "git+file:./Telegram/lib_ui";
      flake = false;
    };

    lib_lottie = {
      url = "git+file:./Telegram/lib_lottie";
      flake = false;
    };

    lib_tl = {
      url = "git+file:./Telegram/lib_tl";
      flake = false;
    };

    lib_spellcheck = {
      url = "git+file:./Telegram/lib_spellcheck";
      flake = false;
    };

    lib_storage = {
      url = "git+file:./Telegram/lib_storage";
      flake = false;
    };

    cmake = {
      url = "git+file:./cmake";
      flake = false;
    };

    expected = {
      url = "git+file:./Telegram/ThirdParty/expected";
      flake = false;
    };

    QR = {
      url = "git+file:./Telegram/ThirdParty/QR";
      flake = false;
    };

    lib_qr = {
      url = "git+file:./Telegram/lib_qr";
      flake = false;
    };

    hunspell = {
      url = "git+file:./Telegram/ThirdParty/hunspell";
      flake = false;
    };

    range_v3 = {
      url = "git+file:./Telegram/ThirdParty/range-v3";
      flake = false;
    };

    nimf = {
      url = "git+file:./Telegram/ThirdParty/nimf";
      flake = false;
    };

    hime = {
      url = "git+file:./Telegram/ThirdParty/hime";
      flake = false;
    };

    fcitx5_qt = {
      url = "git+file:./Telegram/ThirdParty/fcitx5-qt";
      flake = false;
    };

    lib_webrtc = {
      url = "git+file:./Telegram/lib_webrtc";
      flake = false;
    };

    tgcalls = {
      url = "git+file:./Telegram/ThirdParty/tgcalls";
      flake = false;
    };

    lib_webview = {
      url = "git+file:./Telegram/lib_webview";
      flake = false;
    };

    jemalloc = {
      url = "git+file:./Telegram/ThirdParty/jemalloc";
      flake = false;
    };

    dispatch = {
      url = "git+file:./Telegram/ThirdParty/dispatch";
      flake = false;
    };

    kimageformats = {
      url = "git+file:./Telegram/ThirdParty/kimageformats";
      flake = false;
    };

    kcoreaddons = {
      url = "git+file:./Telegram/ThirdParty/kcoreaddons";
      flake = false;
    };

    cld3 = {
      url = "git+file:./Telegram/ThirdParty/cld3";
      flake = false;
    };

    libprisma = {
      url = "git+file:./Telegram/ThirdParty/libprisma";
      flake = false;
    };

    xdg_desktop_portal = {
      url = "git+file:./Telegram/ThirdParty/xdg-desktop-portal";
      flake = false;
    };
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
