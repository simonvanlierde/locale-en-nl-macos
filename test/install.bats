#!/usr/bin/env bats
#
# Unit tests for install.sh. Each test runs against a throwaway $HOME so the
# real environment is never touched.

setup() {
    REPO="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    HOME="$(mktemp -d)"
    export HOME
}

teardown() {
    rm -rf "$HOME"
}

@test "plain run copies the locale and prints export lines" {
    run "$REPO/install.sh"
    [ "$status" -eq 0 ]
    [ -f "$HOME/.locale/en_NL.UTF-8/LC_TIME" ]
    [[ "$output" == *"export LC_ALL=en_NL.UTF-8"* ]]
}

@test "plain run does not create any rc file" {
    run "$REPO/install.sh"
    [ "$status" -eq 0 ]
    [ ! -e "$HOME/.zshrc" ]
    [ ! -e "$HOME/.bash_profile" ]
    [ ! -e "$HOME/.profile" ]
}

@test "--persist writes ~/.zshrc for zsh" {
    SHELL=/bin/zsh run "$REPO/install.sh" --persist
    [ "$status" -eq 0 ]
    grep -qF "# en_NL custom locale" "$HOME/.zshrc"
    grep -qF "export LC_ALL=en_NL.UTF-8" "$HOME/.zshrc"
}

@test "--persist writes ~/.bash_profile for bash" {
    SHELL=/bin/bash run "$REPO/install.sh" --persist
    [ "$status" -eq 0 ]
    grep -qF "# en_NL custom locale" "$HOME/.bash_profile"
    [ ! -e "$HOME/.zshrc" ]
}

@test "--persist is idempotent" {
    SHELL=/bin/zsh "$REPO/install.sh" --persist
    SHELL=/bin/zsh run "$REPO/install.sh" --persist
    [ "$status" -eq 0 ]
    [[ "$output" == *"already present"* ]]
    [ "$(grep -cF "# en_NL custom locale" "$HOME/.zshrc")" -eq 1 ]
}

@test "--persist=<file> honours the override" {
    run "$REPO/install.sh" "--persist=$HOME/custom.rc"
    [ "$status" -eq 0 ]
    grep -qF "export LC_ALL=en_NL.UTF-8" "$HOME/custom.rc"
}
