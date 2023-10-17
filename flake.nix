{
  description = "Nix flake templates";
  outputs = { self }: {
    templates = {
      haskell-hello = {
        path = ./haskell-hello;
        description = "Haskell package development flake with HLS";
      };
      flake-hello = {
        path = ./flake-hello;
        description = "Most basic flake with flake-utils";
      };
    };
  };
}
