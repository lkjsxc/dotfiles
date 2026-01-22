#!/usr/bin/env bash
set -euo pipefail

# Small, portable doc builder using pandoc.
# Output directory: build/

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc not found. Run 'nix develop' (dev shell with pandoc) or 'nix build .#docs' to build docs reproducibly." >&2
  exit 2
fi

mkdir -p build
rm -rf build/* || true

# Use correct order of find options to avoid warnings
for md in $(find docs -maxdepth 2 -name '*.md' | sort); do
  base=$(basename "$md" .md)
  out="build/$base.html"
  echo "Building $md -> $out"
  pandoc -s -o "$out" "$md"
done

# Copy source docs for reference
cp -r docs build/docs

echo "Docs built into build/"
