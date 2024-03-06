# Flake that provides a dev shell including rustc, rustfmt, and rust-analyzer.
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let overlays = [ (import rust-overlay) ];
        forAllSystems = function:
          nixpkgs.lib.genAttrs [
            "x86_64-linux" "aarch64-linux"
            "x86_64-darwin" "aarch64-darwin"
          ] (system: function (import nixpkgs { inherit system overlays; }));
    in {
      devShells = forAllSystems (pkgs:
        let rust = pkgs.rust-bin.stable.latest.default.override {
              extensions = ["rust-src" "rustfmt"];
            };
        in {
          default = pkgs.mkShell {
            buildInputs = [
              rust
              pkgs.rust-analyzer
            ];
          };
        }
      );
    };
}
