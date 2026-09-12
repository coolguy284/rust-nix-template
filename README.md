# rust-nix-template

This repo provides a template nix flake configuration to compile a rust project for both linux and windows in a theoretically convenient and immutable manner. In pratice tag v0.1.0 of this repository already seems to be broken due to a different cargoHash value, so it might be wise to not delete old versions in `build/tags` just in case.

## Usage

See `scripts` folder for usage scripts. To create a new project, copy the following items:
- `.vscode`
- `scripts`
- `src`
- `.gitignore`
- `Cargo.lock`
- `Cargo.toml`
- `flake.lock`
- `flake.nix`
- `rustfmt.toml`

## Info

`scripts-override` folder contains replacement scripts for building this template that should be used instead of the scripts in `scripts`.
