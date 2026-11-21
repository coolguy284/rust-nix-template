# Creates "build/current/<tag name>/<architecture>" folders containing the compiled Rust program.

# Usage:
#   <script file> <path options>
# path options:
#   --no-link
#     nix build will not produce an output symlink
#   --local-link (default)
#     output symlink path is build/symlinks
#   --home-link
#     output symlink path is ~/.cache/git-nix-symlinks/<repo author>/<repo name>
#   --custom-path-link <path>
#     output symlink path is the path given
#   --custom-link <location>
#     output symlink path is the path given without the additional augmentation below
# if output link is to be created nix build will put output link at:
#   <path>/current-normal
#   <path>/current-github
#   <path>/tags-normal/<tag name>
#   <path>/tags-github/<tag name>

set -euo pipefail

origCwd=$(pwd)

cd "${0%/*}/.."

repoRoot=$(pwd)

options=$*

cd $origCwd

store_path=$(nix --extra-experimental-features 'nix-command flakes' build .#build-all-platforms $("$repoRoot/scripts/lib/symlink-args-gen.sh" $origCwd $repoRoot normal current "" $options) --print-out-paths)

cd $repoRoot

mkdir -p build

rm -rf build/current

cp -r $store_path build/current
