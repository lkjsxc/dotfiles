# Documentation

Comprehensive documentation for the Arch Linux dotfiles repository.

## Documentation Structure

### Core Documentation
- **[Installation Guide](./installation.md)** - Complete installation and setup instructions
- **[Configuration Reference](./configuration.md)** - Detailed configuration options and customization
- **[Development Guide](./development.md)** - Development environment and workflow
- **[Troubleshooting](./troubleshooting.md)** - Common issues and solutions

### Component Documentation
- **[Setup Scripts](./setup-scripts.md)** - System installation and package management automation
- **[Configuration Files](./config-files.md)** - Dotfiles and system configuration templates
- **[Automation Scripts](./automation.md)** - Deployment, backup, and maintenance automation
- **[Testing Suite](./testing.md)** - Validation and testing framework
- **[Docker Setup](./docker.md)** - Containerization platform and development services
- **[Wine and NVIDIA Setup](./wine-nvidia.md)** - Gaming configuration with RTX 3070 support

## Quick Reference

### Essential Commands
```bash
# Full system setup
./src/setup-scripts/install-system.sh
./src/setup-scripts/setup-user.sh

# Development environment
./src/setup-scripts/setup-development.sh

# Validate installation
./src/tests/validate-system.sh

# Deploy configurations
./src/automation/deploy-configs.sh

# Docker setup
./src/docker/scripts/install-docker.sh

# Wine and NVIDIA gaming setup
./src/wine-nvidia-setup/install-wine-nvidia.sh
```

### Configuration Files
- `~/.bashrc` - Shell configuration
- `~/.gitconfig` - Git settings
- `~/.config/` - Application configurations
- `/etc/` - System-wide settings

### Common Tasks
- [System setup](./installation.md)
- [Configuration management](./config-files.md)
- [Automation](./automation.md)
- [Testing](./testing.md)
- [Docker deployment](./docker.md)
- [Gaming setup](./wine-nvidia.md)