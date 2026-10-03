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
        
        makeRustPackageParams =
          let
            cargoFileContents = lib.importTOML ./Cargo.toml;
          in
            extraConfig: finalAttrs: {
              pname = cargoFileContents.package.name;
              version = cargoFileContents.package.version;
              
              src = ./.;
              
              cargoLock = {
                lockFile = ./Cargo.lock;
              };
            } // extraConfig;
        
        customPkgs = {
          # https://www.google.com/search?q=nix+derivation+that+copies+other+derivations+into+itself
          # "toString" from https://www.google.com/search?q=nix+convert+derivation+to+a+store+path+string
          copyJoin =
            { pkgsToCombine, pkgSubdir ? "", copySymlinkContents ? false, ... } @ derivationParams:
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
                      # "-L" needed to copy the content of any symbolic links that end up in build output
                      # (if that behavior is chosen by argument to this function)
                      cp -r${if copySymlinkContents then " -L" else ""} ''${folderPkgsArr[i]}$pkgSubdir $out/''${folderNamesArr[i]}
                    done
                  '';
                }
              );
        };
        
        outPkgs = {
          # "pkgs.pkgsCross" from https://www.google.com/search?q=rustplatform+buildrustpackage+specify+output+platform
          # "pkgs.pkgsCross.mingwW64" from https://www.google.com/search?q=nixos+pkgscross+rust+x86_64-pc-windows-gnu
          x86_64-linux = pkgs.rustPlatform.buildRustPackage (makeRustPackageParams {});
          x86-linux = pkgs.pkgsCross.gnu32.rustPlatform.buildRustPackage (makeRustPackageParams {});
          x86_64-windows = pkgs.pkgsCross.mingwW64.rustPlatform.buildRustPackage (makeRustPackageParams {});
          x86-windows = pkgs.pkgsCross.mingw32.rustPlatform.buildRustPackage (makeRustPackageParams {
            # https://discourse.nixos.org/t/trying-to-cross-compile-to-i686-pc-windows-gnu/76237/18
            env.RUSTFLAGS =
              let
                dylibs = [
                  pkgs.pkgsCross.mingw32.windows.pthreads
                  pkgs.pkgsCross.mingw32.windows.mcfgthreads
                ];
                searchDirs = map (a: "-L ${a}/lib") dylibs;
              in
              builtins.concatStringsSep
              " "
              (
                [
                  "-C" "link-arg=-lmcfgthread"
                ]
                ++ searchDirs
              );
          });
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
              copySymlinkContents = true;
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
