{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs }: {
    nixosConfigurations.myNixOS = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ./hardware-configuration.nix ];
    };
  };
}

