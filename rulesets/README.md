# Repository Rulesets

GitHub does not automatically apply ruleset JSON files from this repository. Use `require-pr-review.json` as the source payload when creating repository rulesets through the GitHub REST API or when manually configuring Settings -> Rules -> Rulesets.

## Recommended Ruleset

`require-pr-review.json` targets each repository's default branch with these active rules:

- Restrict deletions.
- Block force pushes.
- Require a pull request before merging.
- Require one approving review.
- Dismiss stale approvals when new commits are pushed.
- Require approval of the most recent reviewable push.
- Require conversation resolution before merging.

The bypass list is empty. Keep it empty for a true no-exceptions policy, or add explicit bypass actors only when you intentionally want admins, teams, apps, or deploy keys to bypass the rules.

## API Endpoint

Create the ruleset per repository with:

```text
POST /repos/{owner}/{repo}/rulesets
```

The token or GitHub App must have repository `Administration: write` permission.
