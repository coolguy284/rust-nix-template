# Creates "build/tags-github-releases/<tag name>" folders containing the GitHub release files for the compiled Rust program as it was at those git tags. Has some specific overrides for this template project that wouldnt be needed in a copy of this project.

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

final_exit_code=0

# https://www.geeksforgeeks.org/linux-unix/bash-scripting-functions/
buildTag(){
  tag=$1
  options=${*:2}
  
  # https://stackoverflow.com/questions/22861580/bash-script-check-if-a-file-contains-a-specific-line/69022922#69022922
  if
    [ -f "./scripts/lib/github-tag-ignore-list.txt" ] &&
    grep -Fxq "$tag" "./scripts/lib/github-tag-ignore-list.txt"
  then
    return
  fi
  
  # https://unix.stackexchange.com/questions/786103/in-bash-how-to-capture-stdout-and-the-exit-code-of-a-command-when-the-e-flag-i/786153#786153
  (cd $orig_cwd && "$repo_root/scripts-override/build-github-one-tag.sh" $tag $options) && true
  exit_code=$?
  
  if [ "$exit_code" -ne 0 ]; then
    final_exit_code=$exit_code
  fi
}

git_tags=$(git tag)

mkdir -p build/tags-github-releases

for tag in $git_tags; do
  buildTag $tag $*
done

exit $final_exit_code
