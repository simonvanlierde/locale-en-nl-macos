#!/usr/bin/env bash
#
# Install the custom en_NL.UTF-8 locale into ~/.locale.
#
# Usage:
#   ./install.sh                  Copy the locale and print the shell config to add.
#   ./install.sh --persist        Also append the config to the rc file of the
#                                 current shell, auto-detected from $SHELL
#                                 (zsh -> ~/.zshrc, bash -> ~/.bash_profile,
#                                 other -> ~/.profile). Idempotent.
#   ./install.sh --persist=<file> Persist to an explicit rc file instead.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCALE="en_NL.UTF-8"
DEST="$HOME/.locale"

EXPORT_LINES=(
    "export PATH_LOCALE=\$HOME/.locale:\${PATH_LOCALE:-}"
    "export LC_ALL=$LOCALE"
)
MARKER="# en_NL custom locale"

# Pick the rc file for the current shell (basename of $SHELL).
default_rc() {
    case "$(basename "${SHELL:-}")" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) echo "$HOME/.bash_profile" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

mkdir -p "$DEST"
cp -a "$SCRIPT_DIR/$LOCALE" "$DEST/"
echo "Installed $LOCALE to $DEST/"

case "${1:-}" in
    --persist)        RC="$(default_rc)" ;;
    --persist=*)      RC="${1#--persist=}" ;;
    "")               RC="" ;;
    *)                echo "Unknown argument: $1" >&2; exit 2 ;;
esac

if [ -n "$RC" ]; then
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
