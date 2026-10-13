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

So numbers keep US grouping (`1,234.56`). The installer exports only `LC_TIME`
and `LC_MONETARY`, and sets `LANG=en_US.UTF-8` when `LANG` is unset.

## Install

```bash
git clone https://github.com/simonvanlierde/locale-en-nl-macos.git
cd locale-en-nl-macos
./install.sh --persist
```

`--persist` copies the locale to `~/.locale` and adds the exports to your shell's
rc file, picked from `$SHELL`. Use `--persist=<file>` to choose the file, or leave
the flag out to get the export lines printed instead.

To uninstall, run `./install.sh --uninstall` (or `--uninstall=<file>`) and open a
new shell. An install from before October 2026 never loaded the locale: run
`./install.sh --uninstall` and then `./install.sh --persist` to replace it.

## Notes

The locale only reaches programs started from a shell that has these variables.
GUI apps follow the formats set in System Settings.

macOS's ssh client forwards `LC_*` variables, so a remote host without
`en_NL.UTF-8` warns about `LC_TIME` and `LC_MONETARY`. Set both to a locale the
host has, in its own shell rc file, or remove `LC_*` from `SendEnv` in
`/etc/ssh/ssh_config`.

## Tests

```bash
shellcheck install.sh copy_locales.sh
bats test/
```

CI also runs a macOS job that turns the locale on and checks the output.

## Licence

GPL-3.0, see [`LICENSE`](LICENSE). The `LC_CTYPE` and `LC_COLLATE` files are
copied unchanged from macOS's `en_US.UTF-8` locale data.
