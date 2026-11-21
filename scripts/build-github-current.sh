# Creates a "build/current-github-release" folder folders containing the GitHub release files for the compiled Rust program.

set -euo pipefail

cd "${0%/*}/.."

options=$*

store_path=$(nix --extra-experimental-features 'nix-command flakes' build .#build-github-releases $(./scripts/lib/link-parse.sh github current "" $options) --print-out-paths)

mkdir -p build

rm -rf build/current-github-release

cp -r $store_path build/current-github-release
