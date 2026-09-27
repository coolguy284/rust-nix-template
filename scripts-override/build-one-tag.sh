# Creates "build/tags/<tag name>/<architecture>" folders containing the compiled Rust program as it was at that git tag.

set -euo pipefail

cd "${0%/*}/.."

tag=$1

if [ "$tag" = "v0.1.0-hash-fix" ] || [ "$tag" = "v0.2.0-hash-fix" ]; then
  ./scripts-override/lib/build-one-old-tag.sh $tag
else
  ./scripts-override/lib/build-one-tag.sh $tag
fi
