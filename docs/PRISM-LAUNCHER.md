# Prism Launcher (Minecraft)

This document explains how Prism Launcher is integrated into this NixOS configuration and provides installation options.

Summary

- The configuration will attempt to use a `prism-launcher` package provided by the repository overlay. By default this is a safe wrapper.
- Optionally you can enable an AppImage-based derivation in the overlay; instructions below.

Installation options

1) Declarative (overlay-provided)

The local overlay `overlays/prism.nix` provides a `prism-launcher` package. By default that package is a small wrapper that prints installation instructions so system evaluation never fails.

2) Flatpak (recommended fallback)

Install Flatpak and then Prism Launcher from Flathub (if available):

```bash
sudo nix profile install "nixpkgs#flatpak"   # or add `flatpak` to systemPackages
flatpak install flathub net.prismlauncher.PrismLauncher || echo "Check Flatpak name on Flathub"
flatpak run net.prismlauncher.PrismLauncher
```

3) AppImage (opt-in in overlay)

The overlay contains an optional AppImage derivation that is disabled by default. To enable it:

1. Open `overlays/prism.nix` and set:

```nix
useAppImage = true;
appImageUrl = "https://github.com/PrismLauncher/PrismLauncher/releases/download/RELEASE/prism-launcher.AppImage";
# Replace sha256 with the correct hash for the AppImage in the fetchurl block.
```

2. Rebuild your system:

```bash
sudo nixos-rebuild switch --flake .#main
```

Notes for maintainers

- The overlay ships a safe default wrapper so system evaluation is robust. When enabling the AppImage derivation, set the correct `sha256` for `fetchurl` to avoid build failures.
- If you prefer, implement a full Nix derivation that builds Prism Launcher from source and replace the `appimagePkg` in `overlays/prism.nix`.
- `modules/gaming.nix` adds `flatpak` to `environment.systemPackages` to make the Flatpak option easy to use.
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
