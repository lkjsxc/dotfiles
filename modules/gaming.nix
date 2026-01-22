{ config, pkgs, lib, ... }:

{
  # Gaming-related convenience additions.
  # Use mkDefault to avoid recursive option evaluation while still allowing
  # user or other modules to override/extend `environment.systemPackages`.
  environment.systemPackages = lib.mkDefault ((config.environment.systemPackages or []) ++ [ pkgs.flatpak ]);

  # Future: add game-specific services, GPU tuning, steam, lutris, mangohud, etc.
}
