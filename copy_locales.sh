#!/usr/bin/env bash

# Set source and destination directories
SOURCE_DIR="/usr/share/locale"
DEST_DIR="$HOME/code/personal/locale-en-nl-macos/reference-files" # Destination for copied files

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

copy_original_files() {
    local src_dir="$1"
    local dst_dir="$2"

    mkdir -p "$dst_dir" # Ensure the target directory exists

    for item in "$src_dir"/*; do
        if [ -L "$item" ] || [ -f "$item" ]; then
            # Get real path of the file and copy it to the destination
            cp "$(realpath "$item")" "$dst_dir/"
            echo "Copied $item to $dst_dir"
        elif [ -d "$item" ]; then
            # Recursively handle subdirectories
            copy_original_files "$item" "$dst_dir/$(basename "$item")"
        fi
    done
}

# Wrapper function to copy locale by name
copy_locale() {
    local locale_name="$1"
    copy_original_files "$SOURCE_DIR/$locale_name" "$DEST_DIR/$locale_name"
}

# Call the copy function for any locale you want to copy
copy_locale "en_US.UTF-8"
copy_locale "nl_NL.UTF-8"

echo "All files copied to $DEST_DIR."
