# Usage

Useful commands:

- Build flake outputs:

```bash
nix build .#nixosConfigurations.main.config.system.build.toplevel
```

- Switch system (root):

```bash
sudo nixos-rebuild switch --flake .#main
```

Replace `#main` with `#your-hostname` to use the antigravity example configuration.
