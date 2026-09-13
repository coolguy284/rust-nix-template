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
        
        lib = nixpkgs.lib;
        # "import nixpkgs { inherit system; }" from https://www.google.com/search?q=nixos+attribute+rustplatform+missing+on+nixpkgs+flake+input
        pkgs = (import nixpkgs { inherit system; }).pkgs;
        
        rustPackageParams =
          let
            cargoFileContents = lib.importTOML ./Cargo.toml;
          in
            finalAttrs: {
              pname = cargoFileContents.package.name;
              version = cargoFileContents.package.version;
              
              src = ./.;
              
              cargoHash = "sha256-M5R9gdFuPWzns38M0pt2dKef84ZkymzOx3vB9HdcS2w";
            };
        
        customPkgs = {
          # https://www.google.com/search?q=nix+derivation+that+copies+other+derivations+into+itself
          # "toString" from https://www.google.com/search?q=nix+convert+derivation+to+a+store+path+string
          copyJoin =
            { pkgsToCombine, pkgSubdir ? "", ... } @ derivationParams:
              pkgs.stdenv.mkDerivation (
                (removeAttrs derivationParams [ "pkgsToCombine" ])
                // {
                  folderNames = builtins.attrNames pkgsToCombine;
                  folderPkgs = map (pkg: toString pkg) (builtins.attrValues pkgsToCombine);
                  inherit pkgSubdir;
                  
                  dontUnpack = true;
                  
                  installPhase = ''
                    # https://stackoverflow.com/questions/9293887/how-to-read-a-space-delimited-string-into-an-array-in-bash/9294015#9294015
                    folderNamesArr=($folderNames)
                    folderPkgsArr=($folderPkgs)
                    
                    mkdir -p $out
                    
                    # https://stackoverflow.com/questions/1445452/shell-script-for-loop-syntax/1445471#1445471
                    # https://stackoverflow.com/questions/1886374/how-to-find-the-length-of-an-array-in-shell/1886483#1886483
                    for i in ''$(seq 0 ''$((''${#folderNamesArr[@]} - 1))); do
                      cp -r ''${folderPkgsArr[i]}$pkgSubdir $out/''${folderNamesArr[i]}
                    done
                  '';
                }
              );
        };
        
        outPkgs = {
          # "pkgs.pkgsCross" from https://www.google.com/search?q=rustplatform+buildrustpackage+specify+output+platform
          # "pkgs.pkgsCross.mingwW64" from https://www.google.com/search?q=nixos+pkgscross+rust+x86_64-pc-windows-gnu
          x86_64-linux = pkgs.rustPlatform.buildRustPackage rustPackageParams;
          #x86-linux = pkgs.pkgsCross.gnu32.rustPlatform.buildRustPackage rustPackageParams;
          x86_64-windows = pkgs.pkgsCross.mingwW64.rustPlatform.buildRustPackage rustPackageParams;
          #x86-windows = pkgs.pkgsCross.mingw32.rustPlatform.buildRustPackage rustPackageParams;
        };
      in
        {
          # packages."${system}".default output left unused in case a nix package output is desired
          
          # "pkgs.symlinkJoin" from https://www.google.com/search?q=nix+combine+multiple+derivations+into+one+big+output
          packages."${system}".build =
            customPkgs.copyJoin {
              name = "build";
              pkgsToCombine = outPkgs;
              pkgSubdir = "/bin";
            };
          
          # https://nixos-and-flakes.thiscute.world/development/intro
          devShells."${system}".default =
            pkgs.mkShell {
              # The following two methods of getting "rustc" and "cargo" (packages or inputsFrom)
              # seem roughly equivalent, so  packages is chosen as it doesnt depend on choice of
              # build outputs
              
              packages = builtins.attrValues pkgs.rustPlatform.rust;
              
              #inputsFrom = [
              #  outPkgs.x86_64-linux
              #];
              
              shellHook = ''
                echo "Entering Rust Development Environment"
              '';
            };
        };
}
