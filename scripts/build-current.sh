set -euo pipefail

cd "${0%/*}/.."

store_path=$(nix build --no-link --print-out-paths)

mkdir -p build

rm -rf build/current

cp -r $store_path build/current
