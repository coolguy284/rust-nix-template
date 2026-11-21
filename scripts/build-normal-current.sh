# Creates "build/current/<tag name>/<architecture>" folders containing the compiled Rust program.

set -euo pipefail

cd "${0%/*}/.."

options=$*

store_path=$(nix --extra-experimental-features 'nix-command flakes' build .#build-all-platforms $(./scripts/lib/link-parse.sh normal current "" $options) --print-out-paths)

mkdir -p build

rm -rf build/current

cp -r $store_path build/current
