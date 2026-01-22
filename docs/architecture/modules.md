# Modules & Refactor Notes

This document lists current module choices and suggested improvements.

Current state:
- `configuration.nix` is the single entry point. It imports `hardware-configuration.nix`.

Suggestions:
- If this repo grows, split `configuration.nix` into `modules/` with focused files for:
  - `packages.nix` — global packages
  - `desktop.nix` — display manager, desktop environment
  - `users.nix` — user accounts and per-user packages

Short-term: Keep changes minimal and prefer adding small modules over large edits.
