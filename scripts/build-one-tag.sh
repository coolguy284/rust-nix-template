# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

set -euo pipefail

cd "${0%/*}/.."

tag=$1

if [ ! -d "build/tags/$tag" ]; then
  echo Building version $tag...
  
  # https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i/786104#786104
  nix build git+file:.?ref=$tag#build-output --no-link || build_result=$?
  
  if [ $build_result -eq 1 ]; then
    echo Error building version $tag
    exit $build_result
  fi
  
  store_path=$(nix build git+file:.?ref=$tag#build-output --no-link --print-out-paths)
  
  cp -r $store_path build/tags/$tag
fi
