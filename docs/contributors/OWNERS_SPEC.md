# OWNERS files

- [Overview](#overview)
- [OWNERS](#owners)
- [OWNERS_ALIASES](#owners_aliases)
- [Code Review using OWNERS files](#code-review-using-owners-files)
  * [The Code Review Process](#the-code-review-process)
  * [Quirks of the Process](#quirks-of-the-process)
- [Maintaining OWNERS files](#maintaining-owners-files)


## Overview
OWNERS files are used to designate responsibility over different parts of the codebase. Today, we use them to assign the **reviewer** and **approver** roles used in our two-phase code review process. The OWNERS files were inspired by [Chromium OWNERS files](https://chromium.googlesource.com/chromium/src/+/master/docs/code_reviews.md), which in turn inspired [GitHub's CODEOWNERS files][CODEOWNERS].

The velocity of a project that uses code review is limited by the number of people capable of reviewing code. The quality of a person's code review is limited by their familiarity with the code under review. Our goal is to address both of these concerns through the prudent use and maintenance of OWNERS files.


## OWNERS
Each directory that contains a unit of independent code or content may also contain an OWNERS file. This file applies to everything within the directory, including the OWNERS file itself, sibling files, and child directories.

OWNERS files are in YAML format and support the following keys:

- `approvers`: a list of GitHub usernames or aliases that can `/approve` a PR
- `labels`: a list of GitHub labels to automatically apply to a PR
- `options`: a map of options for how to interpret this OWNERS file, currently only one:
  - `no_parent_owners`: defaults to `false` if not present; if `true`, exclude parent OWNERS files. Allows the use case where `a/deep/nested/OWNERS` file prevents `a/OWNERS` file from having any effect on `a/deep/nested/bit/of/code`
- `reviewers`: a list of GitHub usernames or aliases that are good candidates to `/lgtm` a PR

The above keys constitute a *simple OWNERS configuration*.

All users are expected to be assignable. In GitHub terms, this means they are either collaborators of the repo, or members of the organization to which the repo belongs.

A typical OWNERS file looks like:

```yaml
approvers:
  - alice
  - bob     # this is a comment
reviewers:
  - alice
  - carol   # this is another comment
  - sig-foo # this is an alias
```


## OWNERS_ALIASES
Each repo may contain at its root an OWNERS_ALIAS file.

OWNERS_ALIAS files are in YAML format and support the following keys:

- `aliases`: a mapping of alias name to a list of GitHub usernames

We use aliases for groups instead of GitHub Teams, because changes to GitHub Teams are not publicly auditable. A sample OWNERS_ALIASES file looks like:

```yaml
aliases:
  sig-foo:
    - david
    - erin
  sig-bar:
    - bob
    - frank
```

GitHub usernames and aliases listed in OWNERS files are case-insensitive.


## Code Review using OWNERS files
This is a simplified description of our [full PR testing and merge workflow][MERGEWORKFLOW] that conveniently forgets about the existence of tests, to focus solely on the roles driven by OWNERS files.

### The Code Review Process
- The **author** submits a PR
- Phase 0: Automation suggests **reviewers** and **approvers** for the PR
  - Determine the set of OWNERS files nearest to the code being changed
  - Choose at least two suggested **reviewers**, trying to find a unique reviewer for every leaf OWNERS file, and request their reviews on the PR
  - Choose suggested **approvers**, one from each OWNERS file, and list them in a comment on the PR
- Phase 1: Humans review the PR
  - **Reviewers** look for general code quality, correctness, sane software engineering, style, etc.
  - Anyone in the organization can act as a **reviewer** with the exception of the individual who opened the PR
  - If the code changes look good to them, a **reviewer** types `/lgtm` in a PR comment or review; if they change their mind, they `/lgtm cancel`
  - Once a **reviewer** has `/lgtm`'ed, [@ceProject-bot][BOT] applies an `lgtm` label to the PR
- Phase 2: Humans approve the PR
  - The PR **author** `/assign`'s all suggested **approvers** to the PR, and optionally notifies them (eg: "pinging @foo for approval")
  - Only people listed in the relevant OWNERS files, either directly or through an alias, as [described above](#owners_aliases), can act as **approvers**, including the individual who opened the PR.
  - **Approvers** look for holistic acceptance criteria, including dependencies with other features, forwards/backwards compatibility, API and flag definitions, etc
  - If the code changes look good to them, an **approver** types `/approve` in a PR comment or review; if they change their mind, they `/approve cancel`
  - [@ceProject-bot][BOT] updates its comment in the PR to indicate which **approvers** still need to approve
  - Once all **approvers** (one from each of the previously identified OWNERS files) have approved, [@ceProject-bot][BOT] applies an `approved` label
- Phase 3: Automation merges the PR:
  - If all of the following are true:
    - All required labels are present (eg: `lgtm`, `approved`)
    - Any blocking labels are missing (eg: there is no `do-not-merge/hold`, `needs-rebase`)
  - And if any of the following are true:
    - there are no pre-submit prow jobs configured for this repo
    - there are pre-submit prow jobs configured for this repo, and they all pass after automatically being re-run one last time
  - Then the PR will automatically be merged

### Quirks of the Process
There are a number of behaviors we've observed that while _possible_ are discouraged, as they go against the intent of this review process.  Some of these could be prevented in the future, but this is the state of today.

- An **approver**'s `/lgtm` is simultaneously interpreted as an `/approve`
  - While a convenient shortcut for some, it can be surprising that the same command is interpreted in one of two ways depending on who the commenter is
  - Instead, explicitly write out `/lgtm` and `/approve` to help observers, or save the `/lgtm` for a **reviewer**
  - This goes against the idea of having at least two sets of eyes on a PR, and may be a sign that there are too few **reviewers** (who aren't also **approver**)
- An **approver** can `/approve no-issue` to bypass the requirement that PR's must have linked issues
  - There is disagreement within the community over whether requiring every PR to have a linked issue provides value
  - Protest is being expressed in the form of overuse of `/approve no-issue`
  - Instead, suggest to the PR **author** that they edit the PR description to include a linked issue
  - This is a sign that we need to actually deliver value with linked issues, or be able to define what a "trivial" PR is in a machine-enforceable way to be able to automatically waive the linked issue requirement
- Technically, anyone who is a member of the kubernetes GitHub organization can drive-by `/lgtm` a PR
  - Drive-by reviews from non-members are encouraged as a way of demonstrating experience and intent to become a collaborator or reviewer
  - Drive-by `/lgtm`'s from members may be a sign that our OWNERS files are too small, or that the existing **reviewers** are too unresponsive
  - This goes against the idea of specifying **reviewers** in the first place, to ensure that **author** is getting actionable feedback from people knowledgeable with the code
- **Reviewers**, and **approvers** are unresponsive
  - This causes a lot of frustration for **authors** who often have little visibility into why their PR is being ignored
  - Many **reviewers** and **approvers** are so overloaded by GitHub notifications that @mention'ing is unlikely to get a quick response
  - If an **author** `/assign`'s a PR, **reviewers** and **approvers** will be made aware of it
  - An **author** can work around this by manually reading the relevant OWNERS files, `/unassign`'ing unresponsive individuals, and `/assign`'ing others
  - This is a sign that our OWNERS files are stale; pruning the **reviewers** and **approvers** lists would help with this
- **Authors** are unresponsive
  - This costs a tremendous amount of attention as context for an individual PR is lost over time
  - This hurts the project in general as its general noise level increases over time
  - Instead, close PR's that are untouched after too long (we currently have a bot do this after 90 days)

## Maintaining OWNERS files
OWNERS files should be regularly maintained. We encourage people to self-nominate or self-remove from OWNERS files via PR's. Ideally in the future we could use metrics-driven automation to assist in this process.

We should strive to:

- grow the number of OWNERS files
- add new people to OWNERS files
- ensure OWNERS files only contain org members and repo collaborators
- ensure OWNERS files only contain people are actively contributing to or reviewing the code they own
- remove inactive people from OWNERS files

Bad examples of OWNERS usage:

- directories that lack OWNERS files, resulting in too many hitting root OWNERS
- OWNERS files that have a single person as both approver and reviewer
- OWNERS files that haven't been touched in over 6 months
- OWNERS files that have non-collaborators present

Good examples of OWNERS usage:

- team aliases are used that correspond to sigs
- there are more `reviewers` than `approvers`
- the `approvers` are not in the `reviewers` section
- OWNERS files that are regularly updated (at least once per release)

[GO-REGEX]: https://golang.org/pkg/regexp/#pkg-overview
[MERGEWORKFLOW]: REVIEWING.md#the-testing-and-merge-workflow
[BOT]: https://github.com/ceProject-bot
[CODEOWNERS]: https://help.github.com/articles/about-codeowners/