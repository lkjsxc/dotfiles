# Flakes and Inputs

This repository uses a Nix flake (`flake.nix`) as the entrypoint for building NixOS.

Key points

- `nixpkgs` is pinned to `nixos-unstable` via a GitHub flake input.
- `antigravity-nix` is added as an input and its default package is included in `environment.systemPackages` for the `main` configuration.

Example snippet (present in `flake.nix`):

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  antigravity-nix = {
    url = "github:jacopone/antigravity-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

To update and rebuild

```bash
nix flake update
sudo nixos-rebuild switch --flake .#main
```
