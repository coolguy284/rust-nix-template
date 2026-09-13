# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

set -euo pipefail

cd "${0%/*}/.."

final_exit_code=0

# https://www.geeksforgeeks.org/linux-unix/bash-scripting-functions/
buildTag(){
  tag=$1
  
  # https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i/786153#786153
  ./scripts/build-one-tag.sh $tag && true
  exit_code=$?
  
  if [ "$exit_code" -ne 0 ]; then
    final_exit_code=$exit_code
  fi
}

gitTags=$(git tag)

mkdir -p build/tags

# https://stackoverflow.com/questions/59838/how-do-i-check-if-a-directory-exists-or-not-in-a-bash-shell-script/59839#59839
for tag in $gitTags; do
  buildTag $tag
done

exit $final_exit_code
