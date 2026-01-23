# Documentation

Comprehensive documentation for the Arch Linux dotfiles repository.

## Documentation Structure

- **[Installation Guide](./installation.md)** - Complete installation and setup instructions
- **[Configuration Reference](./configuration.md)** - Detailed configuration options and customization
- **[Development Guide](./development.md)** - Development environment and workflow
- **[Troubleshooting](./troubleshooting.md)** - Common issues and solutions
- **[Package Reference](./packages.md)** - Package list and descriptions
- **[Architecture](./architecture.md)** - Repository design and structure

## Quick Reference

### Essential Commands
```bash
# Full system setup
./setup-scripts/install-system.sh
./setup-scripts/setup-user.sh

# Development environment
./setup-scripts/setup-development.sh

# Validate installation
./tests/validate-system.sh
```

### Configuration Files
- `~/.bashrc` - Shell configuration
- `~/.gitconfig` - Git settings
- `~/.config/` - Application configurations
- `/etc/` - System-wide settings

### Common Tasks
- [Adding new packages](./packages.md#adding-packages)
- [Custom configurations](./configuration.md#customization)
- [System updates](./troubleshooting.md#system-updates)