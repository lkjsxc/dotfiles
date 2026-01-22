{ config, pkgs, ... }:

{
  # Gaming-related convenience additions.
  environment.systemPackages = with pkgs; (config.environment.systemPackages or []) ++ [ flatpak ];

  # Future: add game-specific services, GPU tuning, steam, lutris, mangohud, etc.
}
