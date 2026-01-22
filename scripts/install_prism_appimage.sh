#!/usr/bin/env bash
set -euo pipefail

# Simple installer for Prism Launcher (AppImage) — downloads latest release from GitHub
# and installs it into ~/bin/prism-launcher (creates ~/bin if missing).

BIN_DIR="$HOME/bin"
TARGET="$BIN_DIR/prism-launcher"

mkdir -p "$BIN_DIR"

URL="https://github.com/PrismLauncher/PrismLauncher/releases/latest/download/Prism-Launcher.AppImage"

if command -v curl >/dev/null 2>&1; then
  echo "Downloading Prism Launcher AppImage from $URL"
  curl -L -o "$TARGET" "$URL"
elif command -v wget >/dev/null 2>&1; then
  echo "Downloading Prism Launcher AppImage from $URL"
  wget -O "$TARGET" "$URL"
else
  echo "Requires curl or wget to download the AppImage." >&2
  exit 2
fi

chmod +x "$TARGET"

echo "Installed Prism Launcher to $TARGET"
echo "Ensure $BIN_DIR is in your PATH, then run 'prism-launcher' to start it."