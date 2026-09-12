# Updates the flake to latest to hopefully get the latest rust compilation toolkit.

set -euo pipefail

cd "${0%/*}/.."

nix flake update
