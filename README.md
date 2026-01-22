# .dotfiles — NixOS dotfiles (Documentation Root)  

**Table of Contents**

- 📁 docs/ — Project documentation (this is the source)  
- ⚙️ configuration.nix — Main system configuration  
- 🧩 hardware-configuration.nix — Hardware generated config  
- 🔧 flake.nix — Flake providing NixOS config and a `docs` package
- 🧪 scripts/ — Helper scripts (e.g., `build_docs.sh`)

---

## Quick commands

- Build docs with Nix: `nix build .#docs` ✅
- Build docs locally (requires `pandoc`): `./scripts/build_docs.sh` ✅
- Enter dev shell with `pandoc`: `nix develop`

---

Notes: This repository follows a strict documentation layout: each directory contains exactly one `README.md` which acts as the directory TOC. Documentation files are kept short (< 300 lines) and source files are kept small (< 200 lines).
