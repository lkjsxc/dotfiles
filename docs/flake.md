# flake.nix details

This flake exposes two NixOS configurations:

- `nixosConfigurations.main` — the primary configuration using `./configuration.nix` and `./hardware-configuration.nix`.
- `nixosConfigurations.your-hostname` — an example configuration that installs `antigravity-nix` as a system package.

Inputs used:

- `nixpkgs` — `github:NixOS/nixpkgs/nixos-unstable`
- `antigravity-nix` — `github:jacopone/antigravity-nix` (follows `nixpkgs`)

To apply the `your-hostname` configuration locally:

```bash
# Example: build or switch to the configuration (requires root)
sudo nixos-rebuild switch --flake .#your-hostname
```
