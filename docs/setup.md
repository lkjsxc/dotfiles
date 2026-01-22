# Setup & Building Docs

This file explains how to use the flake and build the documentation.

Prerequisites:
- Nix (with flakes enabled) or `pandoc` if you want to run the build script.

Build options:

- With Nix (recommended):

  - Build the `docs` package defined in `flake.nix`:
    - `nix build .#docs`  — produces HTML files in `./result/`.

  - Enter a dev shell with `pandoc` available:
    - `nix develop` (or `nix develop --impure` if needed)

- Without Nix (pandoc must be installed):
  - `./scripts/build_docs.sh`

Output: The script writes generated HTML files to `build/`.
