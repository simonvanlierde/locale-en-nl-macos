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

Only `LC_TIME` and `LC_MONETARY` differ from `en_US`, so the installer exports
just those two and leaves `LANG` and the other categories alone.

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

## Uninstall

```bash
./install.sh --uninstall
```

This removes `~/.locale/en_NL.UTF-8` and the block `--persist` added between
the `# en_NL custom locale` marker comments in the auto-detected rc file. Use
`--uninstall=<file>` for a specific file. Open a new shell afterwards.

An older install exported `LC_ALL`; run `./install.sh --uninstall` and then
`./install.sh --persist` to switch to the current exports.

## Notes

Numbers use US grouping (`1,234.56`), not Dutch (`1.234,56`). The language is
English, so `LC_NUMERIC` stays aligned with `en_US`.

The locale only reaches programs started from a shell that has these
environment variables, so terminal programs pick it up; GUI apps ignore them
and follow the formats set in System Settings.

macOS's ssh client forwards `LC_*` variables (`SendEnv LANG LC_*` in
`/etc/ssh/ssh_config`), so a remote host without `en_NL.UTF-8` will warn about
`LC_TIME` and `LC_MONETARY`; set both to a locale it has in its own shell rc
file, or remove `LC_*` from that `SendEnv` line.

## Tests

`shellcheck install.sh copy_locales.sh` lints the scripts; `bats test/` runs the
install unit tests. CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml))
runs both on Linux plus a macOS job that activates the locale and asserts ISO
date / 24-hour output.

## Licence

GPL-3.0; see [`LICENSE`](LICENSE). The `LC_CTYPE` and `LC_COLLATE` files are
copied unchanged from macOS's `en_US.UTF-8` locale data.
