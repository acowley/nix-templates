# If you wish to make use of an overlay from an input flake, change the expression
# `nixpkgs.legacyPackages.${system}` to
# `(import nixpkgs { inherit system overlay; })`
{
  description = "A very basic flake";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      nixpkgsFor = system: nixpkgs.legacyPackages.${system};
    in {
      devShells = forAllSystems (system: {
        default = (nixpkgsFor system).mkShell { buildInputs = [ ]; };
      });
      ## Example packages output
      # packages = forAllSystems (system: rec {
      #   myPackage = (nixpkgsFor system).callPackages ./myPackage.nix {};
      #   default = myPackage;
      # });
    };
}
