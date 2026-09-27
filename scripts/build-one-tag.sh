# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

set -euo pipefail

cd "${0%/*}/.."

tag=$1

# https://stackoverflow.com/questions/59838/how-do-i-check-if-a-directory-exists-or-not-in-a-bash-shell-script/59839#59839
if [ ! -d "build/tags/$tag" ]; then
  echo Building version $tag...
  
  # https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i/786104#786104
  # https://stackoverflow.com/questions/15541321/set-a-parent-shells-variable-from-a-subshell/15543655#15543655
  { nix build git+file:.?ref=$tag#build --no-link && build_result=$?; } || build_result=$?
  
  if [ $build_result -ne 0 ]; then
    echo Error building version $tag
    exit $build_result
  fi
  
  store_path=$(nix build git+file:.?ref=$tag#build --no-link --print-out-paths)
  
  cp -r $store_path build/tags/$tag
fi
