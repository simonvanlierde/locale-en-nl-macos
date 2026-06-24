#!/usr/bin/env bash
#
# Install the custom en_NL.UTF-8 locale into ~/.locale.
#
# Usage:
#   ./install.sh            Copy the locale and print the shell config to add.
#   ./install.sh --persist  Also append the config to ~/.zshrc (idempotent).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCALE="en_NL.UTF-8"
DEST="$HOME/.locale"

EXPORT_LINES=(
    "export PATH_LOCALE=\$HOME/.locale:\${PATH_LOCALE:-}"
    "export LC_ALL=$LOCALE"
)
MARKER="# en_NL custom locale"

mkdir -p "$DEST"
cp -a "$SCRIPT_DIR/$LOCALE" "$DEST/"
echo "Installed $LOCALE to $DEST/"

if [ "${1:-}" = "--persist" ]; then
    RC="$HOME/.zshrc"
    if grep -qF "$MARKER" "$RC" 2>/dev/null; then
        echo "Shell config already present in $RC; skipping."
    else
        {
            echo ""
            echo "$MARKER"
            printf '%s\n' "${EXPORT_LINES[@]}"
        } >>"$RC"
        echo "Appended shell config to $RC. Run: source $RC"
    fi
else
    echo ""
    echo "Add these lines to your shell config (e.g. ~/.zshrc), or re-run with --persist:"
    printf '    %s\n' "${EXPORT_LINES[@]}"
fi
