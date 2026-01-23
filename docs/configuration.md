# Configuration Reference

Detailed configuration options and customization guide.

## Shell Configuration

### Bash Settings (`~/.bashrc`)

Key configuration sections:

```bash
# History control - avoid duplicates and commands starting with space
HISTCONTROL=ignoreboth

# Custom aliases for common commands
alias ll='ls -alF'
alias la='ls -A'
alias vim='nvim'
```

### Environment Variables (`~/.bash_profile`)

Important environment settings:

```bash
# Default editors and programs
export EDITOR="nvim"
export BROWSER="microsoft-edge"

# Input method configuration
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Development paths
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
```

## Development Tools

### Git Configuration (`~/.gitconfig`)

Essential git settings:

```ini
[user]
    email = your-email@example.com
    name = Your Name

[core]
    editor = nvim
    autocrlf = input

[alias]
    st = status
    co = checkout
    ci = commit
    graph = log --oneline --graph --decorate --all
```

### VSCode Settings (`~/.config/Code/User/settings.json`)

Customize your editor experience:

```json
{
    "editor.formatOnSave": true,
    "editor.tabSize": 2,
    "workbench.colorTheme": "Default Dark+",
    "files.exclude": {
        "**/node_modules": true,
        "**/.git": true
    }
}
```

### Neovim Configuration

Install and configure with:

```bash
# Install NvChad (if not already done)
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# Update and install plugins
nvim +PackerSync +qa
```

## System Configuration

### Systemd Services

Enable essential services:

```bash
# Docker
sudo systemctl enable docker
sudo systemctl start docker

# Firewall
sudo systemctl enable ufw
sudo ufw enable

# Automatic updates (optional)
sudo systemctl enable pacman-init.service
```

### Network Configuration

Configure network settings:

```bash
# NetworkManager (if using desktop environment)
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Static IP (if required)
# Edit /etc/systemd/network/10-eth0.network
```

## Desktop Environment

### Font Configuration

Install and configure fonts:

```bash
# Install fonts
sudo pacman -S noto-fonts-cjk noto-fonts-emoji noto-fonts

# Font configuration in ~/.config/fontconfig/fonts.conf
```

### Input Method Setup

Configure fcitx5 for Japanese input:

```bash
# Required packages
sudo pacman -S fcitx5-im fcitx5-mozc

# Environment variables (add to ~/.bash_profile)
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

### Display Manager

If using GNOME or other DE:

```bash
# Enable display manager
sudo systemctl enable gdm.service

# Configure autologin (if desired)
sudo systemctl edit getty@tty1.service
```

## Application Configuration

### Docker

Configure Docker daemon:

```json
// /etc/docker/daemon.json
{
    "registry-mirrors": ["https://mirror.example.com"],
    "data-root": "/var/lib/docker",
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}
```

### Samba Client

Configure network shares:

```bash
# Create mount point
sudo mkdir /mnt/share-name

# Test connection
sudo mount -t cifs //server/share /mnt/share-name \
  -o username=user,password=pass,domain=domain

# Add to /etc/fstab for automatic mounting
//server/share /mnt/share-name cifs credentials=/path/to/credfile 0 0
```

## Customization

### Adding New Packages

1. Edit `setup-scripts/install-packages.sh`
2. Add package to appropriate section:
   ```bash
   # Official repos
   sudo pacman -S package-name
   
   # AUR packages
   yay -S aur-package-name
   ```

### Creating Custom Scripts

1. Add new script to `setup-scripts/`
2. Make it executable:
   ```bash
   chmod +x setup-scripts/custom-script.sh
   ```
3. Include in main setup or call individually

### Modifying Configuration Files

1. Edit templates in `config-files/`
2. Test changes locally:
   ```bash
   cp config-files/shell/.bashrc ~/
   source ~/.bashrc
   ```
3. Commit changes to repository

## Security Configuration

### Firewall Rules

Configure UFW:

```bash
# Default deny incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow ssh

# Allow web traffic (if server)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

### SSH Configuration

Secure SSH server:

```bash
# /etc/ssh/sshd_config
Port 22
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

## Performance Optimization

### System Performance

```bash
# Enable parallel downloads in pacman
sudo sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Optimize memory management
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
```

### Application Performance

Docker optimization:

```json
{
    "storage-driver": "overlay2",
    "max-concurrent-downloads": 10,
    "max-concurrent-uploads": 5
}
```

This configuration reference provides comprehensive guidance for customizing your Arch Linux setup according to your specific needs.