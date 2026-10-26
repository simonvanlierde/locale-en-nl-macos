# Contributing

Thank you for your interest in locale-en-nl-macos. It does what it set out to do, so I fix bugs and
keep its dependencies current, but don't plan new features. Bug reports and pull requests
are welcome. Please read the [Code of Conduct](CODE_OF_CONDUCT.md) first, and report
vulnerabilities as [SECURITY.md](SECURITY.md) describes, not in a public issue.

## Report a bug

Open an [issue](https://github.com/simonvanlierde/locale-en-nl-macos/issues). Say what you did, what
you expected and what happened, with your OS and the commit or version you used.

## Check a change

```bash
shellcheck install.sh copy_locales.sh
bats test/
```

CI runs both, plus a macOS job that turns the locale on and checks the output.

## Write commits and pull requests

- **Commits** follow [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/):
  `type(scope): summary`, in the imperative, lower case, with no period.
- **The pull request title** becomes the squash commit subject, so it follows the same rule.

## Who maintains this

Simon van Lierde maintains locale-en-nl-macos: reviews pull requests and merges them. The
repository belongs to [simonvanlierde](https://github.com/simonvanlierde) on GitHub. Only
maintainers can merge to `main`. If no maintainer can continue, the repository is archived
with a note in the README, and anyone may fork it under its license.
