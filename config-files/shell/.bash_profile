#!/usr/bin/env bash

# Environment variables set at login

# Set PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="microsoft-edge"

# Language settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Input method for Japanese
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Docker
export DOCKER_BUILDKIT=1

# Node.js
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"

# Python
export PYTHONPATH="$HOME/.local/lib/python3.x/site-packages:$PYTHONPATH"

# Custom aliases
if [[ -f "$HOME/.bashrc" ]]; then
    . "$HOME/.bashrc"
fi