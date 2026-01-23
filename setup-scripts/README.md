# Setup Scripts

System installation and package management automation scripts for Arch Linux.

## Available Scripts

- **[`install-system.sh`](./install-system.sh)** - Complete system setup from fresh Arch install
- **[`setup-user.sh`](./setup-user.sh)** - User environment configuration
- **[`install-packages.sh`](./install-packages.sh)** - Package installation automation
- **[`setup-development.sh`](./setup-development.sh)** - Development environment setup
- **[`setup-gaming.sh`](./setup-gaming.sh)** - Gaming tools and Lutris setup
- **[`setup-language.sh`](./setup-language.sh)** - Japanese language input configuration
- **[`setup-network.sh`](./setup-network.sh)** - Network storage and Samba configuration

## Usage

Run scripts in order for complete setup:

```bash
./install-system.sh
./setup-user.sh
./setup-development.sh
./setup-gaming.sh
./setup-language.sh
./setup-network.sh
```

Each script can be run independently for specific configurations.