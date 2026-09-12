# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

set -euo pipefail

cd "${0%/*}/.."

# https://www.geeksforgeeks.org/linux-unix/bash-scripting-functions/
buildTag(){
  tag=$1
  
  if [ ! -d "build/tags/$tag" ]; then
    echo Building version $tag...
    
    store_path=$(nix build git+file:.?ref=$tag#build-output --no-link --print-out-paths)
    
    cp -r $store_path build/tags/$tag
  fi
}

gitTags=$(git tag)

mkdir -p build/tags

# https://stackoverflow.com/questions/59838/how-do-i-check-if-a-directory-exists-or-not-in-a-bash-shell-script/59839#59839
for tag in $gitTags; do
  buildTag $tag
done
