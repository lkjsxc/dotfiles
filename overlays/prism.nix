# Overlay for Prism Launcher. Provides a safe default wrapper and an
# optional AppImage-based package (disabled by default).
final: prev: let
  pkgs = final;
  useAppImage = false; # Set to true to enable fetching the AppImage
  appImageUrl = "https://example.com/prism-launcher.AppImage"; # replace with real URL when enabling
in
let
  wrapper = pkgs.stdenv.mkDerivation {
    pname = "prism-launcher-wrapper";
    version = "0";
    src = null;
    dontUnpack = true;
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/prism-launcher <<'EOF'
#!/bin/sh
echo "Prism Launcher is not packaged. To install, follow ${placeholderDoc:-'docs/PRISM-LAUNCHER.md'}"
EOF
      chmod +x $out/bin/prism-launcher
    '';
  };

  appimagePkg = pkgs.stdenv.mkDerivation {
    pname = "prism-launcher-appimage";
    version = "0";
    src = pkgs.fetchurl {
      url = appImageUrl;
      # integrity / hash left as null so maintainer must set a real hash
      sha256 = "0000000000000000000000000000000000000000000000000000";
    };
    dontUnpack = true;
    buildPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/prism-launcher.AppImage
      chmod +x $out/bin/prism-launcher.AppImage
      cat > $out/bin/prism-launcher <<'EOF'
#!/bin/sh
exec $out/bin/prism-launcher.AppImage "$@"
EOF
      chmod +x $out/bin/prism-launcher
    '';
  };

in {
  prism-launcher = if useAppImage then appimagePkg else wrapper;
}
