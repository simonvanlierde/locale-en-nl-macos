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
#   ./install.sh --uninstall      Remove the locale and the block --persist added
#                                 to the auto-detected rc file.
#   ./install.sh --uninstall=<file>
#                                 Same, for an explicit rc file.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCALE="en_NL.UTF-8"
DEST="$HOME/.locale"

# Only the categories that differ from en_US. LC_ALL would override every
# category, and ssh forwards LC_* to hosts that may not have this locale.
# LANG covers the other categories, so it gets a UTF-8 default where the
# terminal leaves it unset; otherwise text handling would fall back to C.
EXPORT_LINES=(
    "export PATH_LOCALE=\$HOME/.locale:\${PATH_LOCALE:-}"
    "export LANG=\${LANG:-en_US.UTF-8}"
    "export LC_TIME=$LOCALE"
    "export LC_MONETARY=$LOCALE"
)
MARKER="# en_NL custom locale"
END_MARKER="# en_NL custom locale end"

# Pick the rc file for the current shell (basename of $SHELL).
default_rc() {
    case "$(basename "${SHELL:-}")" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) echo "$HOME/.bash_profile" ;;
        *)    echo "$HOME/.profile" ;;
    esac
}

# Delete the marked block from $1, with the blank line written before it.
# Blocks from older versions have no end marker, so a block also ends at the
# first line that is not one of its exports.
remove_block() {
    local rc="$1" tmp
    tmp="$(mktemp)"
    awk -v begin="$MARKER" -v end="$END_MARKER" '
        inblock && $0 == end { inblock = 0; next }
        inblock && /^export (PATH_LOCALE|LANG|LC_ALL|LC_TIME|LC_MONETARY)=/ { next }
        { inblock = 0 }
        $0 == begin { inblock = 1; held = 0; next }
        held { print ""; held = 0 }
        $0 == "" { held = 1; next }
        { print }
        END { if (held) print "" }
    ' "$rc" >"$tmp"
    # Write through cat so a symlinked rc file keeps its link and permissions.
    # The redirect empties the file first, so keep a copy until it succeeds.
    cp "$rc" "$rc.bak"
    cat "$tmp" >"$rc"
    rm -f "$tmp" "$rc.bak"
}

ACTION=install
case "${1:-}" in
    --persist)        RC="$(default_rc)" ;;
    --persist=*)      RC="${1#--persist=}" ;;
    --uninstall)      ACTION=uninstall; RC="$(default_rc)" ;;
    --uninstall=*)    ACTION=uninstall; RC="${1#--uninstall=}" ;;
    "")               RC="" ;;
    *)                echo "Unknown argument: $1" >&2; exit 2 ;;
esac

if [ "$ACTION" = uninstall ]; then
    rm -rf "${DEST:?}/$LOCALE"
    rmdir "$DEST" 2>/dev/null || true
    echo "Removed $DEST/$LOCALE"
    if grep -qxF "$MARKER" "$RC" 2>/dev/null; then
        remove_block "$RC"
        echo "Removed shell config from $RC. Open a new shell to drop the exports."
    else
        echo "No shell config found in $RC."
    fi
    exit 0
fi

mkdir -p "$DEST"
cp -a "$SCRIPT_DIR/$LOCALE" "$DEST/"
echo "Installed $LOCALE to $DEST/"

if [ -n "$RC" ]; then
    if grep -qxF "$MARKER" "$RC" 2>/dev/null; then
        echo "Shell config already present in $RC; skipping."
        if grep -qF "export LC_ALL=$LOCALE" "$RC"; then
            echo "It is from an older version that exports LC_ALL. To update it, run:"
            echo "    $0 --uninstall=$RC && $0 --persist=$RC"
        fi
    else
        {
            echo ""
            echo "$MARKER"
            printf '%s\n' "${EXPORT_LINES[@]}"
            echo "$END_MARKER"
        } >>"$RC"
        echo "Appended shell config to $RC. Run: source $RC"
    fi
else
    echo ""
    echo "Add these lines to your shell config (e.g. ~/.zshrc), or re-run with --persist:"
    printf '    %s\n' "${EXPORT_LINES[@]}"
fi
