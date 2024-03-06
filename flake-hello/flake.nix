# If you wish to make use of an overlay from an input flake, change the expression
# `nixpkgs.legacyPackages.${system}` to
# `(import nixpkgs { inherit system overlay; })`
{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-23.05-darwin;
  };

  outputs = { self, nixpkgs }:
    let forAllSystems = function:
          nixpkgs.lib.genAttrs [
            "x86_64-linux" "aarch64-linux"
            "x86_64-darwin" "aarch64-darwin"
          ] (system: function nixpkgs.legacyPackages.${system});
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = [ ];
        };
      });
    };
}
