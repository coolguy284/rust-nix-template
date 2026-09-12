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
        
        customPkgs = {
          # https://www.google.com/search?q=nix+derivation+that+copies+other+derivations+into+itself
          # "toString" from https://www.google.com/search?q=nix+convert+derivation+to+a+store+path+string
          copyJoin =
            { pkgsToCombine, ... } @ derivationParams:
              pkgs.stdenv.mkDerivation (
                (removeAttrs derivationParams [ "pkgsToCombine" ])
                // {
                  folderNames = builtins.attrNames pkgsToCombine;
                  folderPkgs = map (pkg: toString pkg) (builtins.attrValues pkgsToCombine);
                  
                  pkg1 = outPkgs.x86_64-linux;
                  pkg2 = outPkgs.x86_64-windows;
                  
                  dontUnpack = true;
                  
                  installPhase = ''
                    mkdir -p $out
                    
                    # https://stackoverflow.com/questions/9293887/how-to-read-a-space-delimited-string-into-an-array-in-bash/9294015#9294015
                    folderNamesArr=($folderNames)
                    
                    # https://stackoverflow.com/questions/1445452/shell-script-for-loop-syntax/1445471#1445471
                    for i in `seq 1 1`; do
                      mkdir $out/''${folderNamesArr[i]}
                    done
                    
                    cp -r $pkg1 $out/pkg1
                    cp -r $pkg2 $out/pkg2
                    
                    echo $folderNames > $out/folderNames
                    echo $folderPkgs > $out/folderPkgs
                  '';
                }
              );
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
          packages."${system}".default =
            customPkgs.copyJoin {
              name = "build-out";
              pkgsToCombine = outPkgs;
            };
        };
}
