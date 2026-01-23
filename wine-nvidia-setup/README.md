# Wine and NVIDIA Setup

Configures Arch Linux for gaming with Wine using NVIDIA RTX 3070 graphics.

## Purpose

This module enables the multilib repository and installs 32-bit NVIDIA drivers required for Wine gaming compatibility on RTX 3070 systems.

## Prerequisites

- Arch Linux system
- NVIDIA RTX 3070 GPU
- Root/sudo access
- Basic NVIDIA drivers already installed

## Setup

### Enable Multilib Repository

Edit `/etc/pacman.conf` to enable multilib:

```bash
sudo sed -i '/\[multilib\]/,+1 s/^#//' /etc/pacman.conf
```

### Install NVIDIA 32-bit Drivers

```bash
sudo pacman -Syu
sudo pacman -S lib32-nvidia-utils lib32-mesa lib32-libgl lib32-gcc-libs
```

### Install Wine Dependencies

```bash
sudo pacman -S wine wine-mono winetricks
```

## Validation

Verify 32-bit NVIDIA libraries are installed:

```bash
pacman -Q | grep lib32-nvidia
ldconfig -p | grep libGL.so.1
```

## Usage

After installation, configure Wine for gaming:

```bash
winecfg  # Configure Wine settings
winetricks dxvk vkd3d  # Install DirectX/Vulkan support
```

## Troubleshooting

### Missing 32-bit Libraries

If applications fail to start, verify all 32-bit libraries are present:

```bash
ldd $(which wine) | grep "not found"
```

### OpenGL Issues

Test OpenGL functionality:

```bash
glxinfo | grep "OpenGL renderer"
wine glxgears
```

### Multilib Not Working

Ensure multilib section is uncommented in `/etc/pacman.conf` and run:

```bash
sudo pacman -Syu
```