set -euo pipefail

cd "${0%/*}/.."

nix flake update
