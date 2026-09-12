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
        
        # "import nixpkgs { inherit system; }" from https://www.google.com/search?q=nixos+attribute+rustplatform+missing+on+nixpkgs+flake+input
        pkgs = (import nixpkgs { inherit system; }).pkgs;
        
        rustPackageParams =
          finalAttrs: {
            pname = "rust-nix-compile-test";
            version = "0.1.0";
            
            src = ./.;
            
            cargoHash = "sha256-QipW8C5W0f7yklYMMCJU8vcZ70WP5JpsxX9gcbR8AhA";
          };
        
        outPkgs = {
          x86_64-linux = pkgs.rustPlatform.buildRustPackage rustPackageParams;
          x86_64-windows = pkgs.pkgsCross.mingwW64.rustPlatform.buildRustPackage rustPackageParams;
        };
      in
        {
          # "pkgs.pkgsCross" from https://www.google.com/search?q=rustplatform+buildrustpackage+specify+output+platform
          # "pkgs.pkgsCross.mingwW64" from https://www.google.com/search?q=nixos+pkgscross+rust+x86_64-pc-windows-gnu
          # "pkgs.symlinkJoin" from https://www.google.com/search?q=nix+combine+multiple+derivations+into+one+big+output
          # "toString" from https://www.google.com/search?q=nix+convert+derivation+to+a+store+path+string
          packages."${system}".default =
            pkgs.symlinkJoin {
              name = "build-out";
              paths = [
                (toString outPkgs.x86_64-linux)
                (toString outPkgs.x86_64-windows)
              ];
            };
        };
}
