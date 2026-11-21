# Creates a "build/current-github-release" folder folders containing the GitHub release files for the compiled Rust program.

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

orig_cwd=$(pwd)

cd "${0%/*}/.."

repo_root=$(pwd)

options=$*

cd $orig_cwd

store_path=$(nix --extra-experimental-features 'nix-command flakes' build .#build-github-releases $("$repo_root/scripts/lib/symlink-args-gen.sh" $orig_cwd $repo_root github current "" $options) --print-out-paths)

cd $repo_root

mkdir -p build

rm -rf build/current-github-release

cp -r $store_path build/current-github-release
