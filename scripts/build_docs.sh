#!/usr/bin/env bash
set -euo pipefail

# Small, portable doc builder using pandoc.
# Output directory: build/
mkdir -p build
rm -rf build/* || true

for md in $(find docs -name '*.md' -maxdepth 2 | sort); do
  base=$(basename "$md" .md)
  out="build/$base.html"
  echo "Building $md -> $out"
  pandoc -s -o "$out" "$md"
done

# Copy source docs for reference
cp -r docs build/docs

echo "Docs built into build/"
