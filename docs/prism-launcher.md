# Prism Launcher

This short page documents installing and using **Prism Launcher** (a Minecraft launcher with profile and modpack support).

Installation
- The NixOS configuration in this repo attempts to provide Prism Launcher. If `prism-launcher` is available in your nixpkgs channel you can add it to `environment.systemPackages` and rebuild with:
  - `sudo nixos-rebuild switch --flake .#main`

- This repo falls back to installing Prism Launcher via Flatpak if available, but some Flathub IDs or availability may vary. If Flatpak installation is not available on your system, use the AppImage installer below.

AppImage (recommended fallback)
- Use the helper script to download the latest AppImage and install it into `~/bin`:
  - `./scripts/install_prism_appimage.sh`
- The script downloads `Prism-Launcher.AppImage` from the official GitHub releases and installs it as `~/bin/prism-launcher`.

Usage
- Run it from the application launcher (KDE menu) or run `prism-launcher` from a terminal (ensure `~/bin` is in your PATH).
- Prism Launcher needs Java to run. If you run into issues, ensure a JRE is available (e.g., `openjdk` in `environment.systemPackages`).

Notes
- If your nixpkgs does contain `prism-launcher` you can replace the Flatpak/AppImage approach by adding it to `environment.systemPackages`.
- System-wide Flatpak install is attempted during activation by `system.activationScripts.install-prism-launcher`, but Flathub IDs and availability may change; manual install via Flatpak is:
  - `sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
  - `sudo flatpak install --system -y flathub <PRISM_ID>`
