# rust-nix-template

This repo provides a template nix flake configuration to compile a rust project for both linux and windows in a theoretically convenient and immutable manner. In pratice tags v0.1.0, v0.2.0, v0.3.0 of this repository already seem to be broken due to a different cargoHash value, so it might be wise to not delete old versions in `build/tags` just in case. Additionally, the current version of the repository (for future reference, commit 7ab89b46acf5b60a528a5fa0809536862fd51d9e) can be built with "sha256-Ybt41/2tC5+mGIEnBUJWQUMekaVC3aansKBm1DRR4e8=" and "sha256-nZ8ENnp/u7paJG0sg4Gur+jAwm1FGTSvHXe8/CrBnT4=" as cargoHash values, but not anything else, like "sha256-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaY=".

## Usage

See `scripts` folder for usage scripts. To create a new project, copy the following items:
- `.vscode`
- `scripts`
- `src`
- `.gitignore`
- `cargo-hash.txt`
- `Cargo.lock`
- `Cargo.toml`
- `flake.lock`
- `flake.nix`
- `rustfmt.toml`

## Info

`scripts-override` folder contains replacement scripts for building this template that should be used instead of the scripts in `scripts`.
