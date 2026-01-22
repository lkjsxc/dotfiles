# Configuration notes

This file contains minimal notes about `configuration.nix` and how modules are combined.

- `configuration.nix` and `hardware-configuration.nix` are included by the flake for the `main` system.
- Additional modules should be placed in `modules/` and imported from `configuration.nix`.

Keep modules small and composable.
