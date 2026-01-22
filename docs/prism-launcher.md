# Prism Launcher

This short page documents installing and using **Prism Launcher** (a Minecraft launcher with profile and modpack support).

Installation
- The flake adds `prism-launcher` to `environment.systemPackages` in `configuration.nix`.
- Rebuild the system to install it system-wide:
  - `sudo nixos-rebuild switch --flake .#main`

Usage
- Run it from the application launcher (KDE menu) or run `prism-launcher` from a terminal.
- Prism Launcher needs Java to run. If you run into issues, ensure a JRE is available (e.g., `openjdk` in `environment.systemPackages`).

Notes
- The `prism-launcher` package is the canonical package from `nixpkgs`. If your flake channel is older and lacks it, add it explicitly or use the `devShell` to install locally with `nix-shell -p prism-launcher`.
- If you prefer Flatpak, Prism is available on Flathub as `net.prismlauncher.PrismLauncher`.
