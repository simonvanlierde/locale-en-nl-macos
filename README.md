# en_NL Locale for macOS

Custom `en_NL` locale for macOS: **English language with Dutch conventions** —
euros and ISO `YYYY-MM-DD` dates. Inspired by
[PanderMusubi's locale-en-nl](https://github.com/PanderMusubi/locale-en-nl).

## Install

```bash
git clone https://github.com/simonvanlierde/locale-en-nl-macos.git
cd locale-en-nl-macos
./install.sh --persist   # copies the locale to ~/.locale and updates ~/.zshrc
```

Then reload your shell (`source ~/.zshrc`) and confirm:

```bash
locale          # LC_ALL=en_NL.UTF-8
date +%x        # 2026-06-23  (ISO date)
```

Run `./install.sh` without `--persist` to copy the files and print the export
lines instead of editing your shell config.

### Manual install

```bash
mkdir -p ~/.locale
cp -a en_NL.UTF-8 ~/.locale
```

Add to `~/.zshrc` (or `~/.bashrc`):

```bash
export PATH_LOCALE=$HOME/.locale:${PATH_LOCALE:-}
export LC_ALL=en_NL.UTF-8
```

To scope a single category instead of `LC_ALL`, e.g.:

```bash
export LC_TIME=en_NL.UTF-8
export LC_MONETARY=en_NL.UTF-8
```

## Design

Each locale category is either copied from `en_US` or customized:

| Category      | Source / customization                          |
| ------------- | ----------------------------------------------- |
| `LC_CTYPE`    | `en_US` (identical)                             |
| `LC_COLLATE`  | `en_US` (identical)                             |
| `LC_NUMERIC`  | `en_US` (identical)                             |
| `LC_MESSAGES` | `en_US` yes/no patterns                         |
| `LC_MONETARY` | euro symbol (€/EUR) + `en_US` separators        |
| `LC_TIME`     | `en_US` month/day names + ISO `%Y-%m-%d` date   |

## Repository layout

```bash
├── en_NL.UTF-8/        # the custom locale files
├── install.sh          # copy the locale to ~/.locale (+ optional --persist)
├── copy_locales.sh     # regenerate the local reference baseline for diffing
├── README.md
└── LICENSE
```

`copy_locales.sh` copies the system `en_US` and `nl_NL` locales into a
git-ignored `reference_files/` directory, used only when maintaining the custom
locale.
