# scripts/ — Helper scripts

- `build_docs.sh` — Convert Markdown docs into HTML using `pandoc`. Outputs to `build/`.
- `install_prism_appimage.sh` — Download the Prism Launcher AppImage to `~/bin/prism-launcher` and make it executable.

Usage:
- Make executable: `chmod +x scripts/build_docs.sh scripts/install_prism_appimage.sh`
- Run docs: `./scripts/build_docs.sh`
- Install prism locally: `./scripts/install_prism_appimage.sh`

Note: The scripts are intentionally small and portable. Prefer using the Nix `docs` package for reproducible builds where applicable.
