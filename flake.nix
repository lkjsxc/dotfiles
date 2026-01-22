{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    overlays = [ (import ./overlays/prism.nix) ];
    pkgs = import nixpkgs { inherit system overlays; config = { allowUnfree = true; }; };
  in {
    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [ ./configuration.nix ./hardware-configuration.nix ];
      pkgs = pkgs;
    };
  };
}

