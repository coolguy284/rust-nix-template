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

orig_cwd=$(pwd)

cd "${0%/*}/.."

repo_root=$(pwd)

options=$*

cd $orig_cwd

# For some reason if the contents of this variable are pasted directly into the one use of $symlink_options below, it bypasses "set -e" so even if the command errors it doesnt exit the script; so it must be saved to a variable to trigger "set -e"
symlink_options="$("$repo_root/scripts/lib/symlink-args-gen.sh" $orig_cwd $repo_root normal current "" $options)"

store_path=$(nix --extra-experimental-features 'nix-command flakes' build .#build-all-platforms $symlink_options --print-out-paths)

cd $repo_root

mkdir -p build

rm -rf build/current

cp -r $store_path build/current
