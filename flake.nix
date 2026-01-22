{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    overlays = [ (import ./overlays/prism.nix) ];
    pkgs = import nixpkgs { inherit system overlays; };
  in {
    nixosConfigurations.main = pkgs.lib.nixosSystem {
      system = system;
      modules = [ ./configuration.nix ./hardware-configuration.nix ];
    };
  };
}

