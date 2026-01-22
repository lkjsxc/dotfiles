# scripts/ — Helper scripts

- `build_docs.sh` — Convert Markdown docs into HTML using `pandoc`. Outputs to `build/`.

Usage:
- Make executable: `chmod +x scripts/build_docs.sh`
- Run: `./scripts/build_docs.sh`

Note: The script is intentionally small and portable. Prefer using the Nix `docs` package for reproducible builds.
