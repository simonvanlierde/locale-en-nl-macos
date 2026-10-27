# Security

## Report a vulnerability

Report it privately, through
[a GitHub security advisory](https://github.com/simonvanlierde/locale-en-nl-macos/security/advisories/new)
or by email to <code@duinlab.nl>. Don't open a public issue or pull request for it:
anyone can read those before there is a fix.

Please include:

- What the problem is and where it is: a file, a function or a dependency.
- Steps to reproduce it, or a proof of concept.
- The impact you expect, and the version or commit you saw it in.

I acknowledge a report within 14 days, then tell you whether I can reproduce it and when I
expect a fix.

## Fixes and disclosure

A fix lands on `main`. When it is in, I publish the GitHub security advisory for it and
credit you unless you'd rather not be named.

## Scope

In scope:

- `install.sh`, `copy_locales.sh` and the files they write to your home directory.
- The CI workflow in `.github/workflows`.

Out of scope:

- The locale data itself: report it to
  [PanderMusubi/locale-en-nl](https://github.com/PanderMusubi/locale-en-nl).
- A problem in a dependency that doesn't affect this project. Report it upstream.
