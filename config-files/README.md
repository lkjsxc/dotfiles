# Configuration Files

Dotfiles and system configuration templates for Arch Linux setup.

## Configuration Categories

- **[Shell Configuration](./shell/)** - Bash, Zsh, and shell environment settings
- **[Development Tools](./development/)** - VSCode, Neovim, Git configurations
- **[System Settings](./system/)** - Systemd, network, and service configurations
- **[Desktop Environment](./desktop/)** - Window manager, desktop settings
- **[Application Configs](./applications/)** - Application-specific configurations

## Usage

Deploy configurations using the setup scripts or manually copy files:

```bash
# Deploy all configurations
../setup-scripts/deploy-configs.sh

# Deploy specific category
cp -r shell/* ~/
cp -r development/.config/vim ~/.config/
```

## File Structure

- **`~/.`** - User dotfiles (bashrc, gitconfig, etc.)
- **`~/.config/`** - Application configurations
- **`/etc/`** - System-wide configurations (requires sudo)