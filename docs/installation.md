# Installation Guide

Complete step-by-step installation guide for Arch Linux dotfiles.

## Prerequisites

- Fresh Arch Linux installation (minimum base system)
- Internet connection
- Sudo access
- Partitioned disk with Arch installed

## Quick Installation

```bash
# Clone repository
git clone https://github.com/lkjsxc/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run complete setup
./setup-scripts/install-system.sh
./setup-scripts/setup-user.sh
./setup-scripts/setup-development.sh

# Validate installation
./tests/validate-system.sh
```

## Manual Installation Steps

### 1. System Update

```bash
sudo pacman -Syu
```

### 2. Install Build Tools

```bash
sudo pacman -S --needed git base-devel
```

### 3. Install AUR Helper (yay)

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

### 4. Install Essential Packages

```bash
# System packages
sudo pacman -S neovim git curl wget htop tree rsync

# Development tools
sudo pacman -S gcc make cmake python python-pip nodejs npm

# Desktop environment
sudo pacman -S xorg-server gnome gnome-extra
```

### 5. Install AUR Packages

```bash
yay -S microsoft-edge-stable-bin visual-studio-code-bin opencode
yay -S lutris cifs-utils noto-fonts-cjk fcitx5-im fcitx5-mozc
```

### 6. Configure User Environment

```bash
# Copy configuration files
cp config-files/shell/.bashrc ~/
cp config-files/shell/.bash_profile ~/
cp config-files/development/.gitconfig ~/

# Create directories
mkdir -p ~/Documents ~/Downloads ~/Pictures ~/Videos ~/Music ~/Projects
```

### 7. Setup Development Environment

```bash
# Python environment
python -m pip install --upgrade pip
pip install virtualenv black flake8 pytest

# Node.js environment
npm install -g typescript ts-node yarn

# Docker setup
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```

### 8. Configure Input Method

```bash
# Add to ~/.bash_profile or ~/.xprofile
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

### 9. Setup Samba Client

```bash
# Create mount point
sudo mkdir /mnt/lkjsxc-server

# Test connection (replace with actual server)
sudo mount -t cifs //server/share /mnt/lkjsxc-server -o username=yourname
```

## Post-Installation

### Reboot Required

After Docker setup and user group changes, reboot your system:

```bash
sudo reboot
```

### Verify Installation

Run validation script to check all components:

```bash
./tests/validate-system.sh
```

### Optional Configurations

#### Enable Services

```bash
# Enable automatic system updates
sudo systemctl enable pacman-init.service

# Enable firewall
sudo systemctl enable ufw.service
sudo ufw enable
```

#### Install Additional Software

```bash
# Gaming
./setup-scripts/setup-gaming.sh

# Language support
./setup-scripts/setup-language.sh

# Network storage
./setup-scripts/setup-network.sh
```

## Troubleshooting

### Common Issues

1. **Yay installation fails**
   - Ensure base-devel is installed
   - Check internet connection

2. **Docker permission denied**
   - Reboot after usermod command
   - Verify docker group membership

3. **Font rendering issues**
   - Install fontconfig packages
   - Restart display manager

4. **Input method not working**
   - Verify environment variables
   - Restart session

### Getting Help

- Check [Troubleshooting Guide](./troubleshooting.md)
- Review [Configuration Reference](./configuration.md)
- Check GitHub Issues