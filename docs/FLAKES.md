# Flakes and lockfile

This repository uses Nix flakes. Basic operations:

- Update inputs: `nix flake update`
- Inspect a flake: `nix flake show`
- Rebuild system using flake: `sudo nixos-rebuild switch --flake .#main`

`flake.lock` is a machine-generated lock file capturing exact revisions.

Notes

- Do not hand-edit `flake.lock`; regenerate with `nix flake update` and commit. Keep commit messages explicit, e.g. "chore(flakes): update nixpkgs to <rev>".
