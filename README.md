# en_NL Locale for macOS

Custom locale `en_NL` for macOS that combines English and Dutch locale settings (e.g., euros and year-month-date formatting). Inspired by [PanderMusubi's locale-en-nl](https://github.com/PanderMusubi/locale-en-nl).

## Table of Contents

- [File Structure](#file-structure)
- [Installation](#installation)
  - [Notes](#notes)

## File Structure

```bash
├── en_NL.UTF-8         # Custom locale files combining en_US and nl_NL
├── reference_files     # Original macOS en_US and nl_NL files for reference
├── copy_locales.sh     # Script to copy original locale files to the working directory
├── en_NL.glibc         # Pseudo-glibc description of custom locale
└── README.md
```

## Installation

1. Clone this repository:

    ```bash
    git clone https://github.com/yourusername/locale-en-nl-macos.git
    cd locale-en-nl-macos
    ```

2. Create a custom locale directory:

    ```bash
    mkdir -p ~/.locale
    ```

3. Copy the custom locale files:

    ```bash
    cp -a en_NL.UTF-8 ~/.locale
    ```

4. Set `PATH_LOCALE` accordingly:

    ```bash
    export PATH_LOCALE=~/.locale:$PATH_LOCALE
    ```

5. Set the custom locale:

    ```bash
    export LC_ALL=en_NL.UTF-8
    ```

6. Run `locale` to confirm that the custom locale is applied:

    ```bash
    locale
    ```

### Notes

To make these changes persistent, add the following lines to your shell configuration file (e.g., `~/.bashrc` or `~/.zshrc`):

```bash
export PATH_LOCALE=~/.locale:$PATH_LOCALE
export LC_ALL=en_NL.UTF-8
```

After updating your shell configuration, reload it:

```bash
source ~/.bashrc  # or ~/.zshrc
```

To set specific categories (e.g., date or currency), you can use:

```bash
export LC_TIME=en_NL.UTF-8
export LC_MONETARY=en_NL.UTF-8
```
