# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

set -euo pipefail

cd "${0%/*}/.."

gitTags=$(git tag)

mkdir -p build/tags

# https://stackoverflow.com/questions/59838/how-do-i-check-if-a-directory-exists-or-not-in-a-bash-shell-script/59839#59839
for i in $gitTags; do
  if [ ! -d "build/tags/$i" ]; then
    echo Building version $i...
    
    store_path=$(nix build git+file:.?ref=$i --no-link --print-out-paths)
    
    cp -r $store_path build/tags/$i
  fi
done
