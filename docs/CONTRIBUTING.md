# Contributing

Guidelines for editing this repository:

- Keep individual commits small and focused. Prefer messages like:
  - `docs: add ...`
  - `chore(flakes): update ...`
  - `fix(config): adjust ...`

- Test configuration changes locally before pushing:

  ```bash
  sudo nixos-rebuild switch --flake .#main
  ```

- For large refactors, split `configuration.nix` into `modules/` and add `modules/README.md`.
