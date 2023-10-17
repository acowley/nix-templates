{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-23.05-darwin;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system: 
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ ];
        };
      }
    );
}
