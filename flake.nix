# https://nixos-and-flakes.thiscute.world/development/intro
{
  description = "Rust Nix compilation test.";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs =
    { self, nixpkgs, ... }:
      let
        system = "x86_64-linux";
      in
        {
          # "import nixpkgs { inherit system; }" from https://www.google.com/search?channel=entpr&q=nixos+attribute+rustplatform+missing+on+nixpkgs+flake+input
          packages."${system}".default =
            (import nixpkgs { inherit system; }).pkgs.pkgsCross.mingwW64.rustPlatform.buildRustPackage (finalAttrs: {
              pname = "rust-nix-compile-test";
              version = "0.1.0";
              
              src = ./.;
              
              cargoHash = "sha256-QipW8C5W0f7yklYMMCJU8vcZ70WP5JpsxX9gcbR8AhA";
            });
        };
}
