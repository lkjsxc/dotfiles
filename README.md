# Dotfiles

System configuration managed by LLM agents.

## Structure
- [docs](docs/README.md): Documentation and rules.
- [src](src/README.md): NixOS configuration source.

## Usage
To apply changes:
```bash
sudo nixos-rebuild switch --flake .#main
```
