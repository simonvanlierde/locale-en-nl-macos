# en_NL Locale for macOS

[![CI](https://github.com/simonvanlierde/locale-en-nl-macos/actions/workflows/ci.yml/badge.svg)](https://github.com/simonvanlierde/locale-en-nl-macos/actions/workflows/ci.yml)
[![license](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)

A custom `en_NL.UTF-8` locale for macOS: English language, European conventions.
You get euros, ISO `YYYY-MM-DD` dates and 24-hour time, and your system language
stays English.

Inspired by [PanderMusubi/locale-en-nl](https://github.com/PanderMusubi/locale-en-nl).

## What it changes

| Category                                 | Behaviour                                    |
| ---------------------------------------- | -------------------------------------------- |
| `LC_TIME`                                | English month/day names, ISO `%Y-%m-%d`, 24h |
| `LC_MONETARY`                            | euro (`€` / `EUR`)                           |
| `LC_MESSAGES`                            | `en_US` yes/no patterns                      |
| `LC_CTYPE` / `LC_COLLATE` / `LC_NUMERIC` | identical to `en_US`                         |

Only `LC_TIME` and `LC_MONETARY` differ from `en_US`, so the installer exports
just those two. When `LANG` is unset, it also sets `LANG=en_US.UTF-8`, so the
other categories keep UTF-8 text handling. It leaves an existing `LANG` alone.

## Install

```bash
git clone https://github.com/simonvanlierde/locale-en-nl-macos.git
cd locale-en-nl-macos
./install.sh --persist
```

`--persist` copies the locale to `~/.locale` and adds the exports to the end of
your shell's rc file. It picks that file from `$SHELL` (zsh → `~/.zshrc`, bash →
`~/.bash_profile`, otherwise `~/.profile`). The script then prints the exact
`source` command to reload it.

Without `--persist`, it copies the files and prints the export lines for you to
add yourself. Use `--persist=<file>` to write to a file of your choice.

## Uninstall

```bash
./install.sh --uninstall
```

This removes `~/.locale/en_NL.UTF-8`. It also removes the block that `--persist`
added to the auto-detected rc file, between the `# en_NL custom locale` marker
comments. Use `--uninstall=<file>` for a file of your choice. Open a new shell
afterwards.

An install from before October 2026 wrote a `PATH_LOCALE` list that macOS
cannot read, so the locale never loaded. To replace it, run
`./install.sh --uninstall` and then `./install.sh --persist`.

## Notes

Numbers use US grouping (`1,234.56`), not Dutch (`1.234,56`). The language is
English, so I kept `LC_NUMERIC` the same as `en_US`.

The locale only reaches programs started from a shell that has these
environment variables. Terminal programs pick it up. GUI apps ignore the
variables and follow the formats set in System Settings.

macOS's ssh client forwards `LC_*` variables (`SendEnv LANG LC_*` in
`/etc/ssh/ssh_config`). A remote host without `en_NL.UTF-8` will then warn about
`LC_TIME` and `LC_MONETARY`. To fix that, set both to a locale the host has, in
its own shell rc file, or remove `LC_*` from that `SendEnv` line.

## Tests

`shellcheck install.sh copy_locales.sh` lints the scripts, and `bats test/` runs
the unit tests for the installer. CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml))
runs both on Linux. It also runs a macOS job that turns the locale on and checks
for ISO dates and 24-hour time in the output.

## Licence

GPL-3.0, see [`LICENSE`](LICENSE). The `LC_CTYPE` and `LC_COLLATE` files are
copied unchanged from macOS's `en_US.UTF-8` locale data.
