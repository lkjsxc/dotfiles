# Arch Linux Dotfiles

Comprehensive Arch Linux system configuration and automation repository designed for AI agent development.

## Repository Structure

- **[`src/`](./src/)** - Source code and implementation
  - [`setup-scripts/`](./src/setup-scripts/) - System installation and package management scripts
  - [`config-files/`](./src/config-files/) - Configuration files and dotfiles
  - [`automation/`](./src/automation/) - Deployment and automation utilities
  - [`tests/`](./src/tests/) - Validation and testing scripts
  - [`docker/`](./src/docker/) - Docker setup and containerization
- **[`docs/`](./docs/)** - Documentation and guides
- **[`AGENTS.md`](./AGENTS.md)** - AI agent development guidelines

## Quick Start

```bash
# Clone repository
git clone https://github.com/lkjsxc/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run initial setup
./src/setup-scripts/install-system.sh

# Configure user environment
./src/setup-scripts/setup-user.sh

# Validate installation
./src/tests/validate-system.sh
```

## Key Features

- **Automated System Setup** - Complete Arch Linux installation automation
- **Package Management** - Comprehensive software installation with pacman/yay
- **Development Environment** - VSCode, Neovim, Git configuration
- **Japanese Language Support** - fcitx5 + mozc input method
- **Gaming Setup** - Lutris and gaming tools
- **Network Storage** - Samba client configuration
- **Docker Platform** - Complete containerization setup
- **AI-First Design** - Optimized for AI agent development workflow

## Documentation

See [docs/README.md](./docs/README.md) for complete documentation.

## System Requirements

- Arch Linux (x86_64)
- Internet connection for package installation
- Sudo access for system configuration

## License

Apache License 2.0 - see [LICENSE](./LICENSE) for details.