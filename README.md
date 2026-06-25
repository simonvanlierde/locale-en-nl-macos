# en_NL Locale for macOS

A custom `en_NL.UTF-8` locale for macOS: English language, European conventions.
Euros, ISO `YYYY-MM-DD` dates, and 24-hour time — without switching your system
language away from English.

Inspired by [PanderMusubi/locale-en-nl](https://github.com/PanderMusubi/locale-en-nl).

## What it changes

| Category                                 | Behaviour                                    |
| ---------------------------------------- | -------------------------------------------- |
| `LC_TIME`                                | English month/day names, ISO `%Y-%m-%d`, 24h |
| `LC_MONETARY`                            | euro (`€` / `EUR`)                           |
| `LC_MESSAGES`                            | `en_US` yes/no patterns                      |
| `LC_CTYPE` / `LC_COLLATE` / `LC_NUMERIC` | identical to `en_US`                         |

## Install

```bash
git clone https://github.com/simonvanlierde/locale-en-nl-macos.git
cd locale-en-nl-macos
./install.sh --persist
```

`--persist` copies the locale to `~/.locale` and appends the exports to your
shell's rc file, auto-detected from `$SHELL` (zsh → `~/.zshrc`, bash →
`~/.bash_profile`, otherwise `~/.profile`). The script prints the exact `source`
command to reload.

Without `--persist` it copies the files and prints the export lines for you to
add manually. Use `--persist=<file>` to target a specific file.

## Notes

Numbers use US grouping (`1,234.56`), not Dutch (`1.234,56`). The language is
English, so `LC_NUMERIC` stays aligned with `en_US`.

## Tests

`shellcheck install.sh copy_locales.sh` lints the scripts; `bats test/` runs the
install unit tests. CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml))
runs both on Linux plus a macOS job that activates the locale and asserts ISO
date / 24-hour output.
