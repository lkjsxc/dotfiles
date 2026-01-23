# Setup Scripts Documentation

System installation and package management automation scripts for Arch Linux.

## Available Scripts

- **[`install-system.sh`](../../src/setup-scripts/install-system.sh)** - Complete system setup from fresh Arch install
- **[`setup-user.sh`](../../src/setup-scripts/setup-user.sh)** - User environment configuration
- **[`install-packages.sh`](../../src/setup-scripts/install-packages.sh)** - Package installation automation
- **[`setup-development.sh`](../../src/setup-scripts/setup-development.sh)** - Development environment setup
- **[`setup-gaming.sh`](../../src/setup-scripts/setup-gaming.sh)** - Gaming tools and Lutris setup
- **[`setup-language.sh`](../../src/setup-scripts/setup-language.sh)** - Japanese language input configuration
- **[`setup-network.sh`](../../src/setup-scripts/setup-network.sh)** - Network storage and Samba configuration

## Usage

Run scripts in order for complete setup:

```bash
./src/setup-scripts/install-system.sh
./src/setup-scripts/setup-user.sh
./src/setup-scripts/setup-development.sh
./src/setup-scripts/setup-gaming.sh
./src/setup-scripts/setup-language.sh
./src/setup-scripts/setup-network.sh
```

Each script can be run independently for specific configurations.

## Script Features

### System Installation
- Fresh Arch Linux installation automation
- Base system configuration
- User and group setup
- Essential package installation

### Package Management
- Automated pacman and yay setup
- Package group installation
- AUR helper configuration
- Dependency resolution

### Specialized Setup
- Development environment (VSCode, Neovim, Git)
- Gaming platform (Lutris, Steam)
- Japanese language support (fcitx5, mozc)
- Network storage (Samba client)