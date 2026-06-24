#!/usr/bin/env bash
#
# Regenerate the local reference baseline of macOS system locales.
# Output (reference_files/) is git-ignored and used only for diffing when
# maintaining the custom en_NL locale.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="/usr/share/locale"
DEST_DIR="$SCRIPT_DIR/reference_files"

# Copy a locale directory, resolving symlinks so the real files land on disk.
copy_locale() {
    local name="$1"
    local src="$SOURCE_DIR/$name"
    local dst="$DEST_DIR/$name"

    find "$src" -type f -o -type l | while read -r item; do
        local rel="${item#"$src"/}"
        mkdir -p "$dst/$(dirname "$rel")"
        cp "$(realpath "$item")" "$dst/$rel"
    done
    echo "Copied $name to $dst"
}

copy_locale "en_US.UTF-8"
copy_locale "nl_NL.UTF-8"

echo "Reference files written to $DEST_DIR."
