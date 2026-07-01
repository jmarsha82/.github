# jmarsha82 GitHub Defaults

This repository stores default community health files and reusable GitHub configuration for repositories owned by `jmarsha82`.

GitHub uses supported files in this public `.github` repository as defaults for owned repositories that do not define their own versions.

## Included defaults

- `PULL_REQUEST_TEMPLATE.md` - default pull request checklist and review prompt.
- `rulesets/require-pr-review.json` - reusable repository ruleset payload for requiring pull requests and reviews on the default branch.
- `rulesets/README.md` - notes for applying the ruleset to repositories.
- `scripts/apply-ruleset.ps1` - applies the ruleset to selected repositories using the GitHub REST API.
