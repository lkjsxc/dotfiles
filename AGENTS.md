# AGENTS.md

Guidelines for AI agents working in this NixOS dotfiles repository.

## Build / Lint / Test Commands

### Documentation Build
```bash
# Build documentation using Nix flake
nix build .#docs

# Alternative: Direct pandoc build
mkdir -p build && rm -rf build/*
for f in docs/*.md; do base=$(basename "$f" .md); pandoc -s -o build/$base.html "$f"; done
cp -r docs build/docs
```

### Development Environment
```bash
# Enter development shell with pandoc
nix develop

# Manual script execution (if scripts/build_docs.sh exists)
./scripts/build_docs.sh
```

### Testing
```bash
# Verify HTML generation
if ! ls build/*.html >/dev/null 2>&1; then echo "No HTML files generated"; exit 1; fi

# CI/CD equivalent (GitHub Actions runs this on PR)
nix build .#docs && mkdir -p build && cp -r result/* build/
```

### Linting/Formatting
- **No explicit linting configured** - follow Nix style guidelines below
- Use standard Nix formatting (2-space indentation where applicable)
- Validate with `nix flake check` if flake.nix exists

## Code Style Guidelines

### File Structure & Organization
- **Every directory MUST contain a README.md** with directory purpose
- **Strict file size limits**: Code <200 lines, Docs <300 lines
- **Deep recursive directory structures** preferred over flat organization
- **Delete unused content immediately** - no archival or commented code
- **Refactor frequently** to maintain small file sizes

### Nix Code Style
```nix
# Use consistent attribute set syntax
{
  imports = [ ./hardware-configuration.nix ];
  
  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1";
    useOSProber = true;
  };
  
  # Group related configurations
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };
}
```

### Imports & Dependencies
- **Prefer Nix flakes** for reproducible builds
- **Use local paths** for importing related modules: `./module.nix`
- **Explicit imports** over implicit in all configuration files
- **Version pins** through flake inputs, not manual version strings

### Naming Conventions
- **Files**: kebab-case for all files (`hardware-configuration.nix`, `build-docs.sh`)
- **Directories**: kebab-case (`nixos-config/`, `development-tools/`)
- **Nix attributes**: camelCase for system options, kebab-case for custom packages
- **Variables**: descriptive names, avoid abbreviations (`inputMethod` not `im`)

### Error Handling
- **Use Nix built-in validation**: `nix flake check`, `nix-instantiate --parse`
- **Graceful degradation** in optional modules
- **Clear error messages** in custom functions with `throw`/`abort`
- **Document failure modes** in module README files

### Documentation Style
- **Minimal human-friendly comments** (agents don't need explanatory comments)
- **Function over form** - prioritize functionality
- **Structured READMEs**: Purpose, Usage, Dependencies, Examples
- **Code examples** over prose explanations
- **Link to external docs** rather than duplicating information

### Git Workflow
- **Commit frequently** with clear, concise messages
- **Semantic commit prefixes**: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`
- **No WIP commits** - each commit should be logically complete
- **Branch for major features** if working collaboratively

### NixOS Configuration Patterns
```nix
# User configuration template
users.users.username = {
  isNormalUser = true;
  description = "Full Name";
  extraGroups = [ "networkmanager" "wheel" ];
  shell = pkgs.zsh;
  packages = with pkgs; [ 
    kdePackages.kate 
  ];
};

# Package management
environment.systemPackages = with pkgs; [
  # Essential tools
  git
  vim
  
  # Desktop environment
  firefox
  microsoft-edge
];

# Service configuration
services.pipewire = {
  enable = true;
  alsa.enable = true;
  pulse.enable = true;
};
```

### Shell Scripts
- **Strict mode**: `set -euo pipefail`
- **Portable bash**: avoid bashisms, target `/usr/bin/env bash`
- **Error messages to stderr**: `echo "Error: message" >&2`
- **Cleanup handling**: use traps for temporary files

### Project-Specific Rules
- **AI-agent first design**: no human UX considerations required
- **Bold architectural changes** allowed and encouraged
- **No backward compatibility** concerns
- **Immediate deletion** of obsolete content
- **Best practices** over convenience

### Example Module Structure
```
module-name/
├── README.md          # Module purpose and usage
├── default.nix        # Main module implementation
├── config.nix         # Configuration options
└── tests/             # Integration tests (if applicable)
    └── basic.nix
```

## Repository Context

This is a **personal NixOS dotfiles repository** designed for:
- Arch Linux system configuration management
- Reproducible builds using Nix flakes
- AI-agent centric development workflow
- Japanese language support (fcitx5 + mozc)
- Development tools and gaming setup

The repository follows a **minimalist, function-first approach** with strict size constraints and frequent refactoring cycles.