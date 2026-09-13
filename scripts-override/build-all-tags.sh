# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag. Has some specific overrides for this template project that wouldnt be needed in a copy of this project.

set -euo pipefail

cd "${0%/*}/.."

final_exit_code=0

# https://www.geeksforgeeks.org/linux-unix/bash-scripting-functions/
buildOldTag(){
  tag=$1
  
  # https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i/786153#786153
  ./scripts-override/lib/build-one-old-tag.sh $tag && true
  exit_code=$?
  
  if [ "$exit_code" -ne 0 ]; then
    final_exit_code=$exit_code
  fi
}

mkdir -p build/tags

# Custom tag overrides:
buildOldTag v0.1.0
buildOldTag v0.2.0

# Remaining tags can be built normally:
./scripts/build-all-tags.sh
