# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag. Has some specific overrides for this template project that wouldnt be needed in a copy of this project.

set -euo pipefail

cd "${0%/*}/.."

cp -r $(nix build git+file:.?ref=v0.1.0 --no-link --print-out-paths) build/tags/v0.1.0
cp -r $(nix build git+file:.?ref=v0.2.0 --no-link --print-out-paths) build/tags/v0.2.0
./scripts/build-all-tags.sh
