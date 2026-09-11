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
          packages."${system}".rust-nix-compile-test =
            rustPlatform.buildRustPackage (finalAttrs: {
              pname = "rust-nix-compile-test";
              version = "0.1.0";
              
              src = ./.;
              
              cargoHash = "";
            });
        };
}
