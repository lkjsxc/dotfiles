# Prism Launcher (Minecraft)

This document explains how Prism Launcher is integrated into this NixOS configuration and provides installation options.

Summary

- The configuration will attempt to use a `prism-launcher` package from the active `nixpkgs`.
- If `prism-launcher` is not available, a small placeholder binary will be installed and this doc will explain manual installation options.

Installation options

1) Declarative (if available in nixpkgs)

If `prism-launcher` exists in the nixpkgs used by your flake, it will be added to the `lkjsxc` user packages automatically.

2) Flatpak (recommended fallback)

Install Flatpak and then Prism Launcher from Flathub (if available):

```bash
sudo nix profile install "nixpkgs#flatpak"   # or add `flatpak` to systemPackages
flatpak install flathub net.prismlauncher.PrismLauncher || echo "Check Flatpak name on Flathub"
flatpak run net.prismlauncher.PrismLauncher
```

3) AppImage / Binary

Download the AppImage or binary from the official Prism Launcher releases and place it in `~/.local/bin` or `/opt/prism-launcher`.

Example (AppImage):

```bash
mkdir -p ~/.local/bin
curl -L -o ~/.local/bin/prism-launcher.AppImage "<RELEASE_URL>"
chmod +x ~/.local/bin/prism-launcher.AppImage
# Optionally create a tiny wrapper
cat > ~/.local/bin/prism-launcher <<'EOF'
#!/bin/sh
~/.local/bin/prism-launcher.AppImage "$@"
EOF
chmod +x ~/.local/bin/prism-launcher
```

Notes for maintainers

- This repo includes a lightweight overlay skeleton at `overlays/prism.nix`. If you want to make a proper Nix package for Prism Launcher, implement the derivation there and add the overlay to your flake inputs.
- The module `modules/gaming.nix` adds `flatpak` to `environment.systemPackages` to make the Flatpak option easier.
