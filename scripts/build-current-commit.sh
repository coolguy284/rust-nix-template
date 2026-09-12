# Creates "build/current/<tag name>/<architecture>" folders containing the compiled Rust program.

set -euo pipefail

cd "${0%/*}/.."

store_path=$(nix build .#build-output --no-link --print-out-paths)

mkdir -p build

rm -rf build/current

cp -r $store_path build/current
