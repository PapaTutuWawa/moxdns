{
  description = "moxlib";
  inputs = {
    nixpkgs.url = "github:PapaTutuWawa/nixpkgs/nixos-unstable-flutter-2.13.0-0.1.pre";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      config.android_sdk.accept_license = true;
    };
    android = pkgs.androidenv.composeAndroidPackages {
      # TODO: Find a way to pin these
      #toolsVersion = "26.1.1";
      #platformToolsVersion = "31.0.3";
      #buildToolsVersions = [ "31.0.0" ];
      #includeEmulator = true;
      #emulatorVersion = "30.6.3";
      platformVersions = [ "28" ];
      includeSources = false;
      includeSystemImages = true;
      systemImageTypes = [ "default" ];
      abiVersions = [ "x86_64" ];
      includeNDK = false;
      useGoogleAPIs = false;
      useGoogleTVAddOns = false;
    };
    pinnedJDK = pkgs.jdk11;
  in {
    devShell = pkgs.mkShell {
      buildInputs = with pkgs; [
        flutterPackages.beta pinnedJDK android.platform-tools flutterPackages.dart-beta # Flutter
	      gitlint jq # Code hygiene
	      ripgrep # General utilities

        # Flutter dependencies for linux desktop
        atk
        cairo
        clang
        cmake
        epoxy
        gdk-pixbuf
        glib
        gtk3
        harfbuzz
        ninja
        pango
        pcre
        pkg-config
        xorg.libX11
        xorg.xorgproto
      ];

      # Make Flutter build on desktop
      CPATH = "${pkgs.xorg.libX11.dev}/include:${pkgs.xorg.xorgproto}/include";
      LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ atk cairo epoxy gdk-pixbuf glib gtk3 harfbuzz pango ];

      ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
      JAVA_HOME = pinnedJDK;
      ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";
    };
  });
}
