# rust-nix-template

This repo provides a template nix flake configuration to compile a rust project for both linux and windows in a theoretically convenient and immutable manner. In practice there are some issues with this, see "Declarativity Bugs" below.

## Template Usage

See `scripts` folder for usage scripts. To create a new project, copy the following items:
- `.cargo`
- `.vscode`
- `scripts`
- `src`
- `.gitignore`
- `Cargo.lock`
- `Cargo.toml`
- `flake.lock`
- `flake.nix`
- `rustfmt.toml`

The "Building" and "Installation as a Nix Flake" are also applicable and can be copied to the new project `README.md`.

## Building

To build, install the Nix package manager, and run the appropriate "build-" script in the scripts folder.

## Installation as a Nix Flake

This GitHub repository is a nix flake. To install the latest release, add the following input to `flake.nix`:

```nix
{
  inputs = {
    ...
    rust-nix-template.url = "github:coolguy284/rust-nix-template/latest-release";
    # optionally add this as well:
    rust-nix-template.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  # This readme assumes that you are passing flake inputs to the Nix system configuration. Example for a NixOS system shown below (adapted from https://drakerossman.com/blog/how-to-convert-default-nixos-to-nixos-with-flakes):
  outputs =
    { self, nixpkgs, ... }:
    
    {
      nixosConfigurations = {
        systemName =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
            ];
            specialArgs = {
              # This is the key, pass "inputs" as an extra argument to each Nix module:
              inputs = self.inputs;
            };
          };
      };
    }
}
```

Then, add the input to the system packages in any Nix module's configuration like so:

```nix
{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.rust-nix-template.packages.${pkgs.stdenv.hostPlatform.system}
  ];
}
```

## Info

`scripts-override` folder contains replacement scripts for building this template that should be used instead of the scripts in `scripts`.

## Declarativity Bugs

In pratice tags v0.1.0, v0.2.0, v0.3.0 of this repository already seem to be broken due to a different cargoHash value, so it might be wise to not delete old versions in `build/tags` just in case. Additionally, the current version of the repository (for future reference, commit 7ab89b46acf5b60a528a5fa0809536862fd51d9e) can be built with "sha256-Ybt41/2tC5+mGIEnBUJWQUMekaVC3aansKBm1DRR4e8=" and "sha256-nZ8ENnp/u7paJG0sg4Gur+jAwm1FGTSvHXe8/CrBnT4=" as cargoHash values, but not some other values, like "sha256-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaY=".
