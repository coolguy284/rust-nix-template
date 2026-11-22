# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag. Has some specific overrides for this template project that wouldnt be needed in a copy of this project.

# Usage:
#   <script file> <tag name> <path options>
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

repoPath="${0%/*}/.."

tag=$1
options=${*:2}

if [ "$tag" = "v0.1.0-hash-fix" ] || [ "$tag" = "v0.2.0-hash-fix" ]; then
  "$repoPath/scripts-override/lib/build-normal-one-old-tag.sh" $tag $options
elif [ "$tag" = "v0.3.0" ] || [ "$tag" = "v0.4.0" ]; then
  "$repoPath/scripts-override/lib/build-normal-one-old2-tag.sh" $tag $options
else
  "$repoPath/scripts-override/lib/build-normal-one-tag.sh" $tag $options
fi
