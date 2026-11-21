# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

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

cd "${0%/*}/../.."

tag=$1
options=${*:1}

# https://stackoverflow.com/questions/59838/how-do-i-check-if-a-directory-exists-or-not-in-a-bash-shell-script/59839#59839
if [ ! -d "build/tags/$tag" ]; then
  echo Building version $tag...
  
  # https://stackoverflow.com/questions/22861580/bash-script-check-if-a-file-contains-a-specific-line/69022922#69022922
  if
    [ -f "./scripts-override/lib/tag-ignore-list.txt" ] &&
    grep -Fxq "$tag" "./scripts-override/lib/tag-ignore-list.txt"
  then
    echo Error: tag $tag is in ignore list
    exit 1
  fi
  
  # https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i/786104#786104
  # https://stackoverflow.com/questions/15541321/set-a-parent-shells-variable-from-a-subshell/15543655#15543655
  { nix --extra-experimental-features 'nix-command flakes' build git+file:.?ref=$tag $(./scripts/lib/symlink-args-gen.sh normal tag $tag $options) && build_result=$?; } || build_result=$?
  
  if [ $build_result -ne 0 ]; then
    echo Error building version $tag
    exit $build_result
  fi
  
  store_path=$(nix --extra-experimental-features 'nix-command flakes' build git+file:.?ref=$tag $(./scripts/lib/symlink-args-gen.sh normal tag $tag $options) --print-out-paths)
  
  cp -r $store_path build/tags/$tag
fi
