# Arch Linux Dotfiles

Comprehensive Arch Linux system configuration and automation repository designed for AI agent development.

## Repository Structure

- **[`setup-scripts/`](./setup-scripts/)** - System installation and package management scripts
- **[`config-files/`](./config-files/)** - Configuration files and dotfiles
- **[`docs/`](./docs/)** - Documentation and guides
- **[`tests/`](./tests/)** - Validation and testing scripts
- **[`automation/`](./automation/)** - Deployment and automation utilities

## Quick Start

```bash
# Clone repository
git clone https://github.com/lkjsxc/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run initial setup
./setup-scripts/install-system.sh

# Configure user environment
./setup-scripts/setup-user.sh

# Validate installation
./tests/validate-system.sh
```

## Key Features

- **Automated System Setup** - Complete Arch Linux installation automation
- **Package Management** - Comprehensive software installation with pacman/yay
- **Development Environment** - VSCode, Neovim, Git configuration
- **Japanese Language Support** - fcitx5 + mozc input method
- **Gaming Setup** - Lutris and gaming tools
- **Network Storage** - Samba client configuration
- **AI-First Design** - Optimized for AI agent development workflow

## Documentation

- [Installation Guide](./docs/installation.md)
- [Configuration Reference](./docs/configuration.md)
- [Troubleshooting](./docs/troubleshooting.md)
- [Development Guide](./docs/development.md)

## System Requirements

- Arch Linux (x86_64)
- Internet connection for package installation
- Sudo access for system configuration

## License

Apache License 2.0 - see [LICENSE](./LICENSE) for details.