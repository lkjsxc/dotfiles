# Configuration Files Documentation

Dotfiles and system configuration templates for Arch Linux setup.

## Configuration Categories

- **[Shell Configuration](../../src/config-files/shell/)** - Bash, Zsh, and shell environment settings
- **[Development Tools](../../src/config-files/development/)** - VSCode, Neovim, Git configurations
- **[System Settings](../../src/config-files/system/)** - Systemd, network, and service configurations
- **[Desktop Environment](../../src/config-files/desktop/)** - Window manager, desktop settings
- **[Application Configs](../../src/config-files/applications/)** - Application-specific configurations

## Usage

### Deploy Configurations

```bash
# Deploy all configurations
./src/automation/deploy-configs.sh

# Deploy specific category
./src/automation/deploy-configs.sh --category development

# Deploy manually
cp -r src/config-files/shell/* ~/
cp -r src/config-files/development/.config/vim ~/.config/
```

### Configuration Management

- **User Configuration** (`~/`) - Personal dotfiles and preferences
- **Application Configuration** (`~/.config/`) - Application-specific settings
- **System Configuration** (`/etc/`) - System-wide settings (requires sudo)

## File Structure

### Shell Configuration
- `.bashrc` - Bash shell configuration
- `.zshrc` - Zsh shell configuration
- `.profile` - Shell profile settings
- `.inputrc` - Input configuration

### Development Configuration
- `.config/vim/` - Neovim configuration
- `.config/vscode/` - VSCode settings
- `.gitconfig` - Git configuration
- `.gitignore` - Global git ignore patterns

### System Configuration
- Systemd service files
- Network configuration
- User and group settings
- Security configurations

### Desktop Configuration
- Window manager settings
- Display configuration
- Input device settings
- Theme and appearance