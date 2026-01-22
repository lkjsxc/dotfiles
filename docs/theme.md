# KDE/Plasma Dark Theme

This project configures a dark appearance for KDE Plasma by placing default
configuration files into `/etc/skel` via `environment.etc` in `configuration.nix`.

Files added to skel:

- `.config/kdeglobals` — sets `ColorScheme=BreezeDark`, widget style and basic options.
- `.config/plasmarc` — sets Plasma theme name to `BreezeDark`.

How it works:
- New users get these files from `/etc/skel` on account creation.
- To force the theme for the current user, copy the files from `/etc/skel/.config/` to your `~/.config/` and restart Plasma or logout/login.

Apply changes:

1. Edit `configuration.nix` as needed.
2. Rebuild the system:

```bash
sudo nixos-rebuild switch
```

Customization:
- Replace `BreezeDark` with another installed color scheme or theme name.
- You can add more KDE config files under `environment.etc` for finer control.

