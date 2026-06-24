# Branch Finish

Use this when implementation is complete and the next step is commit, push, PR, merge, keep, discard, or cleanup.

```text
Task ID:
Selected Route: branch_finish
Layer: lightweight | medium | review_gated
Status: ready | blocked | not-verified

Completion Checks:
- tests/checks required:
- tests/checks run:
- result:
- not-verified reason:

Repository State:
- current branch:
- base branch:
- remote:
- worktree type: normal | named worktree | detached/external | unknown
- clean worktree: yes | no
- staged files:
- unstaged files:
- untracked files:

Changed Files Summary:
- TODO

Scope / Secret / Runtime Guard:
- scope expected:
- runtime artifacts:
- secret risk:
- ignored local state:

Integration Options:
1. Push branch / create PR:
   - platform detected:
   - auth/tool available:
   - worktree preserved for PR feedback:
2. Keep branch as-is:
   - branch:
   - path:
3. Merge locally:
   - requires explicit Human approval:
   - merge target:
   - post-merge tests:
4. Discard/delete:
   - requires exact confirmation:
   - commits at risk:
   - branch/worktree cleanup plan:

Chosen Option:

Actions Taken:
- TODO

Actions Not Taken:
- TODO

Residual Risk:
- TODO
```
