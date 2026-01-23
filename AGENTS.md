# AGENTS.md

Guidelines for AI agents working in this Arch Linux dotfiles repository.

## Build / Lint / Test Commands

### System Setup Commands
```bash
# Update system packages
sudo pacman -Syu

# Install AUR helper (yay)
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd .. && rm -rf yay

# Install essential packages
yay -S microsoft-edge-stable-bin visual-studio-code-bin neovim

# Install fonts and input methods
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts fcitx5-im fcitx5-mozc

# Install gaming tools
yay -S lutris

# Install samba client
yay -S cifs-utils
sudo mkdir /mnt/lkjsxc-server

# Install Wine and NVIDIA 32-bit drivers for RTX 3070
./src/wine-nvidia-setup/install-wine-nvidia.sh

# Install Docker and Docker Compose
sudo pacman -S docker docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"

# Or use the installation script
./docker/scripts/install-docker.sh
```

### Development Environment
```bash
# Install development tools
sudo pacman -S git neovim
yay -S visual-studio-code-bin opencode

# Git configuration (update email as needed)
git config --global user.email "lkjsxc@gmail.com"
git config --global user.name "lkjsxc"
```

### Testing Commands
```bash
# Verify package installations
pacman -Q | grep -E "(neovim|git|fcitx5)"
yay -Q | grep -E "(microsoft-edge|visual-studio-code|lutris)"

# Test git configuration
git config --list

# Check mount points (for samba)
mount | grep cifs

# Verify Docker installation
docker --version
docker-compose --version
sudo systemctl status docker

# Test Docker functionality
docker run hello-world
./docker/tests/test-docker.sh

# Verify Wine and NVIDIA 32-bit setup
./src/wine-nvidia-setup/tests/validate-setup.sh
```

### Linting/Validation
```bash
# Check for broken package dependencies
pacman -Qk

# Clean orphan packages
sudo pacman -Rns $(pacman -Qtdq)

# Validate shell scripts
bash -n setup_scripts/*.sh
```

## Code Style Guidelines

### File Structure & Organization
- **Every directory MUST contain a README.md** with directory purpose
- **Strict file size limits**: Code <200 lines, Docs <300 lines
- **Deep recursive directory structures** preferred over flat organization
- **Delete unused content immediately** - no archival or commented code
- **Use kebab-case for all files and directories**

### Shell Script Style
```bash
#!/usr/bin/env bash
# Always use strict mode
set -euo pipefail

# Use descriptive variable names
readonly PACKAGE_MANAGER="yay"
readonly INSTALL_DIR="/opt/custom-packages"

# Functions for complex operations
install_package() {
    local package_name="$1"
    echo "Installing $package_name..."
    yay -S "$package_name"
}

# Error messages to stderr
error_exit() {
    echo "Error: $1" >&2
    exit 1
}
```

### Configuration Files
- **Use clear section headers** with descriptive comments
- **Group related settings** together
- **Use consistent formatting** (2-space indentation where applicable)
- **Document special requirements** in adjacent README files

### Imports & Dependencies
- **Use absolute paths** for critical system files
- **Prefer yay over pacman** for AUR packages
- **Pin versions** when specific package versions are required
- **Document dependency chains** in setup scripts

### Naming Conventions
- **Files**: kebab-case (`setup-scripts.sh`, `system-config.md`)
- **Directories**: kebab-case (`development-tools/`, `gaming-setup/`)
- **Variables**: snake_case for shell, descriptive names
- **Functions**: snake_case, verb-noun pattern (`install_packages()`, `configure_system()`)

### Error Handling
- **Always use strict mode**: `set -euo pipefail`
- **Validate inputs** in shell functions
- **Graceful degradation** for optional components
- **Clear error messages** to stderr with context
- **Cleanup handlers** for temporary resources

### Documentation Style
- **Minimal comments** - this is agent-first development
- **Structured READMEs**: Purpose, Prerequisites, Usage, Troubleshooting
- **Command examples** over lengthy explanations
- **Reference external docs** rather than duplicating
- **Keep it under 300 lines per file**

### Git Workflow
- **Commit frequently** with clear, concise messages
- **Semantic prefixes**: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- **No WIP commits** - each commit should be logically complete
- **Test commands** before committing setup scripts

### Pacman/AUR Patterns
```bash
# System update pattern
sudo pacman -Syu

# Package installation patterns
sudo pacman -S package-name          # Official repos
yay -S package-name                  # AUR packages

# Package management
pacman -Q | grep search-term         # Find installed packages
pacman -Qi package-name              # Package info
pacman -Rns package-name             # Remove package

# Development tools
sudo pacman -S --needed git base-devel  # Build dependencies
```

### System Configuration Patterns
```bash
# Service management
sudo systemctl enable service-name
sudo systemctl start service-name
sudo systemctl status service-name

# User management
sudo useradd -m -G wheel,audio,video username
sudo passwd username

# Filesystem operations
sudo mkdir -p /mount/point
sudo mount -t cifs //server/share /mount/point -o credentials=/path/to/cred
```

### Project-Specific Rules
- **AI-agent first design** - no human UX considerations
- **Bold changes** allowed and encouraged
- **No backward compatibility** concerns
- **Immediate deletion** of obsolete content
- **Best practices** over convenience
- **Test on actual Arch Linux** when possible

### Example Module Structure
```
arch-setup/
├── README.md              # Module purpose and setup steps
├── install-packages.sh     # Package installation script
├── config-files/          # Configuration file templates
│   ├── .bashrc
│   └── .gitconfig
└── tests/                 # Validation scripts
    ├── check-packages.sh
    └── verify-config.sh
```

## Repository Context

This is a **personal Arch Linux dotfiles repository** designed for:
- Arch Linux system configuration management
- Package management with pacman and yay
- AI-agent centric development workflow
- Japanese language support (fcitx5 + mozc)
- Development tools setup (VSCode, Neovim, Git)
- Gaming configuration (Lutris, Wine, NVIDIA 32-bit drivers)
- Samba client setup for network shares

The repository follows a **minimalist, function-first approach** with strict size constraints and frequent refactoring cycles. All setup is designed to be automated and reproducible across Arch Linux installations.