# Usage:
# 1. Initialize the flake: `nix flake init -t github:acowley/nix-templates#haskell-hello`
# 2. Set the `pkg-name` variable in this flake to your package's name
# 3. Initialize your cabal package: `nix run .#init`
#
# Now you can enter your environment with `nix develop`, or, if you
# use `direnv` (recommended), `echo 'use flake' > .envrc && direnv
# allow`.
{
  description = "A Haskell package";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkg-name = "my-package";
          pkgs = import nixpkgs {
            inherit system;
          };
          haskell = pkgs.haskellPackages;
          haskell-overlay = final: prev: {
            ${pkg-name} = hspkgs.callCabal2nix pkg-name ./. {};
            # Add here any package overrides you may need
          };
          hspkgs = haskell.override {
            overrides = haskell-overlay;
          };
          input-script = pkgs.writeShellApplication {
            name = "cabal-init";
            runtimeInputs = [hspkgs.ghc hspkgs.cabal-install];
            text = ''
              cabal init -p ${pkg-name}
            '';
          };
      in {
        packages = pkgs;
        apps.init = {
          program = "${init-script}/bin/cabal-init";
          type = "app";
        };
        inherit haskell-overlay;
        defaultPackage = hspkgs.${pkg-name};
        devShell = hspkgs.shellFor {
          packages = p: [p.${pkg-name}];
          root = ./.;
          withHoogle = true;
          buildInputs = with hspkgs; [
            haskell-language-server
            cabal-install
          ];
        };
      }
    );
}
