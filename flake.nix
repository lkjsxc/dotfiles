{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ./hardware-configuration.nix ];
    };

    # A tiny Nix package that builds HTML docs from Markdown using pandoc.
    packages.${system}.docs = pkgs.runCommand "dotfiles-docs" {
      buildInputs = [ pkgs.pandoc ];
      src = ./.;
    } ''
      mkdir -p $out
      for f in $src/docs/*.md; do
        base=$(basename "$f" .md)
        pandoc -s -o $out/$base.html "$f"
      done
      cp -r $src/docs $out/docs
    '';

    # Dev shell to make it convenient to build docs locally.
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [ pkgs.pandoc ];
      shellHook = ''
        echo "Dev shell: pandoc available to build docs (run scripts/build_docs.sh)"
      '';
    };
  };
}

