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

cd "${0%/*}/.."

tag=$1
options=${*:1}

if [ "$tag" = "v0.1.0-hash-fix" ] || [ "$tag" = "v0.2.0-hash-fix" ]; then
  ./scripts-override/lib/build-one-old-tag.sh $tag $options
else if [ "$tag" = "v0.3.0" ] || [ "$tag" = "v0.4.0" ]; then
  ./scripts-override/lib/build-one-old2-tag.sh $tag $options
else
  ./scripts-override/lib/build-one-tag.sh $tag $options
fi
