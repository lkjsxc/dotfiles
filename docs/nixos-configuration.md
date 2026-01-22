# NixOS Configuration Overview

This project stores NixOS configuration as a flake. Key files:

- `flake.nix` — exposes `nixosConfigurations.main`, a `docs` package, and a `devShell`.
- `configuration.nix` — the main system configuration (packages, services, users).
- `hardware-configuration.nix` — auto-generated hardware specifics.

Quick guidelines for changes:
- Make atomic, small edits and commit frequently.
- Keep system packages small and explicit in `environment.systemPackages`.
- For large changes consider splitting configuration into modules and importing them.

Example: To add a package globally, add it to `environment.systemPackages` inside `configuration.nix` and run `sudo nixos-rebuild switch --flake .#main`.
