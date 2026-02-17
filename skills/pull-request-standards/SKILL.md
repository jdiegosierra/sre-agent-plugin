---
name: pull-request-standards
description: >
  Pull request standards and conventions. Reference this skill
  to ensure PRs follow the correct title format, description structure,
  branch naming, and quality checklist.
---

# Pull Request Standards

These are the standards every pull request should follow.

## Branch naming

Use the format: `<type>/<ticket-or-short-description>`

Examples:
- `feat/PROJ-123-add-user-auth`
- `fix/PROJ-456-null-pointer-on-login`
- `chore/update-dependencies`

Valid types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `perf`, `style`.

## PR title

Follow **Conventional Commits** format:

```
<type>(<scope>): <short imperative description>
```

- **type**: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `perf`, `style`
- **scope** (optional): module or area affected (e.g., `auth`, `api`, `ui`)
- **description**: imperative mood, lowercase, no period at end, max 72 chars

Examples:
- `feat(auth): add OAuth2 login flow`
- `fix(api): handle null response from payment gateway`
- `chore: upgrade Node.js to v22`

## PR description

Every PR **must** include the following sections:

```markdown
## Summary

<!-- 1-3 bullet points explaining WHAT changed and WHY -->

- Added OAuth2 login flow to support SSO for enterprise customers
- Refactored auth middleware to support multiple providers

## Changes

<!-- Detailed list of the technical changes, grouped by area -->

### API
- Added `POST /auth/oauth2/callback` endpoint
- Updated `AuthMiddleware` to accept JWT from OAuth2 provider

### Database
- Added `oauth_tokens` table migration

## How to test

<!-- Step-by-step instructions a reviewer can follow to verify the changes -->

1. Set `OAUTH_CLIENT_ID` and `OAUTH_SECRET` in `.env`
2. Run `npm run dev`
3. Navigate to `/login` and click "Sign in with Google"
4. Verify redirect and token exchange completes

## Related issues

<!-- Link the ticket(s) this PR addresses. Use closing keywords. -->

Closes #123
```

### Rules for the description

1. **Summary** must explain the "what" and the "why", not just the "what".
2. **Changes** must be technical and grouped by module/area when touching multiple parts.
3. **How to test** must be actionable — a reviewer should be able to follow these steps without asking questions.
4. **Related issues** must use GitHub closing keywords (`Closes`, `Fixes`, `Resolves`) so issues auto-close on merge.

## Workflow

When the user asks you to create a PR, follow this process:

1. **Analyze changes**: Run `git status` and `git diff` against the base branch to understand all changes.
2. **Identify scope**: Determine the type, scope, and a concise description.
3. **Generate title**: Build the PR title in conventional commit format.
4. **Write description**: Fill all four required sections based on the actual diff.
5. **Check for issues**: Look for related issues or tickets mentioned in commits or conversation.
6. **Create the PR**: Use `gh pr create` with the generated title and body.
7. **Report back**: Show the user the PR URL and a summary of what was created.

## Quality checklist (verify before creating)

- [ ] Title follows `type(scope): description` format
- [ ] Summary explains both what and why
- [ ] Changes section covers all modified areas
- [ ] Test instructions are reproducible
- [ ] Related issues are linked with closing keywords
- [ ] No sensitive data (tokens, passwords, .env contents) in the diff
- [ ] PR targets the correct base branch
