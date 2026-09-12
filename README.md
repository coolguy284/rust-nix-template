# rust-nix-template

This repo provides a template nix flake configuration to compile a rust project for both linux and windows in a theoretically convenient and immutable manner. In pratice tag v0.1.0 of this repository already seems to be broken due to a different cargoHash value.

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
