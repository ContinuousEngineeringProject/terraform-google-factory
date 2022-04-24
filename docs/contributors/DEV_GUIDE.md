# Development Guide
This doc explains the development guide for the project when contributing to the codebase. It should serve as a reference for all contributors, and be useful especially to new and infrequent submitters.

<!-- TOC -->
- [Git Recipes](#git-recipes)
  * [Commit message Guidelines](#commit-message-guidelines)
  * [Create a new branch](#Create-a-new-branch)
  * [Push commits](#Push-commits)
  * [Squash and rebase](#Squash-and-rebase)
  * [Signoff](#Signoff)
- [PR Preparation Recipes](#pr-preparation-recipes)
  * [Unit Tests](#unit-testing)
  * [Integration Tests](#integration-testing)
  * [end-to-end Tests](#end-to-end-testing)
  * [Linting and Formatting](#Linting-and-Formatting)
  * [Generating terraform docs](#Generating-terraform-docs)
<!-- /TOC -->


## Git Recipes
This section contains various recipes for using git.

### Commit message Guidelines
The project uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) as it's commit message format. These are particularly important as semantic releases are in use, and they use the commit messages to determine the type of changes in the codebase. Following formalized conventions for commit messages the semantic release automatically determines the next [semantic version](https://semver.org) number and generates a changelog based on the conventional commit.

The commit message should be structured as follows:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

The commit contains the following structural elements, to communicate intent:

1. Any line of the commit message cannot be longer 100 characters! This allows the message to be easier to read on GitHub as well as in various git tools.
2. The _description_ contains a succinct statement of the change. It should use the imperative, present tense: "change" not "changed" nor "changes", don't capitalize the first letter and no dot (.) at the end.
3. `fix:` a commit of the _type_ fix patches a bug in the codebase (this correlates with `PATCH` in Semantic Versioning).
4. `feat:` a commit of the _type_ `feat` introduces a new feature to the codebase (this correlates with `MINOR` in Semantic Versioning).
5. `BREAKING CHANGE:` a commit that has a _footer_ `BREAKING CHANGE:`, or appends a `!` after the _type/scope_, introduces a breaking API change (correlating with `MAJOR` in Semantic Versioning). A `BREAKING CHANGE` can be part of commits of any _type_.
6. _types_ other than `fix:` and `feat:` are allowed, such as `chore:`, `refactor:` & `docs:` but will have no implicit effect in Semantic Versioning (unless they include a BREAKING CHANGE).
7. _footers_ other than `BREAKING CHANGE:` may be provided and follow a convention similar to [git trailer format](https://git-scm.com/docs/git-interpret-trailers).
8. A **scope** may be provided to a commit’s _type_, to provide additional contextual information and is contained within parenthesis, e.g., `feat(parser): add ability to parse arrays`.


### Create a new branch
First, ensure that your local repository is up-to-date with the latest version of terraform-google-factory. More details on [GitHub help](https://help.github.com/articles/syncing-a-fork/).

```sh
git fetch upstream
git checkout master
git merge upstream/master
```

Now you can create a new branch for your change:

```sh
git checkout -b <BRANCH-NAME>
```

You can check on which branch your on with `git branch`. You should see a list of all local branches. The current branch is indicated with a little asterisk.


### Push commits
To push our commits to the fork on GitHub you need to specify a destination. A destination is defined by the remote, and a branch name. Earlier, the remote url of our fork was given the default name of `origin`. The branch should be given the same name as our local one. This makes it easy to identify corresponding branches.

```sh
git push --set-upstream origin <BRANCH-NAME>
```

Now Git knows the destination. Next time when you want to push commits you just need to enter `git push`.

### Squash and rebase
So you are happy with your development and are ready to prepare the PR. Before going further, let's squash and rebase your work.

This is a bit more advanced but required to ensure a proper Git history of The project. Git allows you to [rebase](https://git-scm.com/docs/git-rebase) commits. In other words: it allows you to rewrite the commit history.

Let's take an example.

```sh
git rebase --interactive @~3
```

The `3` at the end of the command represents the number of commits that should be modified. An editor should open and present a list of last three commit messages:

```sh
pick 911c35b Add "How to contribute to The project" tutorial
pick 33c8973 Begin workflow
pick 3502f2e Refactoring and typo fixes
```

In the case above we should merge the last 2 commits in the commit of this tutorial (`Add "How to contribute to The project" tutorial`). You can "squash" commits, i.e. merge two or more commits into a single one.

All operations are written before the commit message. Replace `pick` with an operation. In this case `squash` or `s` for short:

```sh
pick 911c35b Add "How to contribute to The project" tutorial
squash 33c8973 Begin workflow
squash 3502f2e Refactoring and typo fixes
```

We also want to rewrite the commits message of the third last commit. We forgot "docs:" as prefix according to the code contribution guidelines. The operation to rewrite a commit is called `reword` (or `r` as shortcut).

You should end up with a similar setup:

```sh
reword 911c35b Add "How to contribute to The project" tutorial
squash 33c8973 Begin workflow
squash 3502f2e Refactoring and typo fixes
```

Close the editor. It should open again with a new tab. A text is instructing you to define a new commit message for the last two commits that should be merged (aka "squashed"). Save the file and close the editor again.

A last time a new tab opens. Enter a new commit message and save again. Your terminal should contain a status message. Hopefully this one:

```sh
Successfully rebased and updated refs/heads/<BRANCH-NAME>.
```

Check the commit log if everything looks as expected. Should an error occur you can abort this rebase with `git rebase --abort`.

In case you already pushed your work to your fork, you need to make a force push

```sh
git push --force
```

Last step, to ensure that your change would not conflict with other changes done in parallel by other contributors, you need to rebase your work on the latest changes done on the master branch. Simply:

```sh
git checkout master #Move to local master branch
git fetch upstream #Retrieve change from master branch
git merge upstream/master #Merge the change into your local master
git checkout <BRANCH-NAME> #Move back to your local branch where you did your development
git rebase master
```

Handle any conflicts and make sure your code builds and all tests pass. Then force push your branch to your remote.

### Signoff
A [Developer Certificate of Origin](https://en.wikipedia.org/wiki/Developer_Certificate_of_Origin) is required for all commits. It can be provided using the [signoff](https://git-scm.com/docs/git-commit#Documentation/git-commit.txt---signoff) option for `git commit` or by GPG signing the commit. The developer certificate is available at (https://developercertificate.org/).

The project enforces the DCO using the a [bot](https://github.com/probot/dco). You can view the details on the DCO check by viewing the `Checks` tab in the GitHub pull request.

![DCO signoff check](https://user-images.githubusercontent.com/13410355/42352794-85fe1c9c-8071-11e8-834a-05a4aeb8cc90.png)

#### How to sign your commits
There are a couple of ways to ensure your commits are signed. Described below are three different ways to sign your commits: using git signoff, using GPG, or using webhooks.

##### Git signoff
Git signoff adds a line to your commit message with the user.name and user.email values from your git config. Use git signoff by adding the `--signoff` or `-s` flag when creating your commit. This flag must be added to each commit you would like to sign.

```sh
git commit -m -s "docs: my commit message"
```

If you'd like to keep your personal email address private, you can use a GitHub-provided `no-reply` email address as your commit email address. GitHub provides [good instructions on setting your commit email address](https://docs.github.com/en/github/setting-up-and-managing-your-github-user-account/setting-your-commit-email-address).

##### GPG sign your commits
A more secure alternative is to GPG sign all your commits. This has the advantage that as well as stating your agreement to the DCO it also creates a trust mechanism for your commits. There is a good guide from GitHub on how to set this up:

1) If you don't already have a GPG key, then follow [this guide to create one](https://help.github.com/en/articles/generating-a-new-gpg-key).

2) Now you have a GPG key, tell [tell GitHub about your key so that it can verify your commits](https://help.github.com/en/articles/adding-a-new-gpg-key-to-your-github-account). Once you upload your public gpg key to your GitHub account, GitHub will mark commits that you sign with the `verified` label.

3) To sign commits locally, you can add the `-S` flag when creating your commit. For more information on signing commits locally, follow [this guide to see how to sign your commit](https://help.github.com/en/articles/signing-commits).

4) You can configure git to always use signed commits by running

```sh
git config --global user.signingkey <key id>
```

The process to find the key id is described in [this guide on checking for existing GPG keys](https://help.github.com/en/articles/checking-for-existing-gpg-keys).

5) Set up a keychain for your platform. This is entirely optional but means you don't need to type your passphrase every time and allows git to run headless. If you are using a Mac GPG Suite is a good way to do this. If you are on another platform please open a PR against this document and add your recommendations!

##### Use a webhook to sign your commits
Alternatively, you can use a hook to make sure all your commits messages are signed off.

1) Run:
```sh
mkdir -p ~/.git-templates/hooks
```
```sh
git config --global init.templatedir ~/.git-templates
```

2) Then add this to `~/.git-templates/hooks/prepare-commit-msg`:

```bash
#!/bin/sh

COMMIT_MSG_FILE=$1  # The git commit file.
COMMIT_SOURCE=$2    # The current commit message.

# Add "Signed-off-by: <user> <email>" to every commit message.
SOB=$(git var GIT_COMMITTER_IDENT | sed -n 's/^\(.*>\).*$/Signed-off-by: \1/p')
git interpret-trailers --in-place --trailer "$SOB" "$COMMIT_MSG_FILE"
if test -z "$COMMIT_SOURCE"; then
/usr/bin/perl -i.bak -pe 'print "\n" if !$first_line++' "$COMMIT_MSG_FILE"
fi
```

3) Make sure the file is executable:
```sh
chmod u+x ~/.git-templates/hooks/prepare-commit-msg
```

4) Run `git init` on the repo you want to use the hook on.

Note that this will not override the hooks already defined on your local repo. It adds the `Signed-off-by: ...` line after the commit message has been created by the user.


## PR Preparation Checks
Prior to creating a pull request you will need to perform a set of checks, you can execute `make pr-prep` to run all the checks.

### Unit Testing
[Unit Tests](./TEST_GUIDE.md#unit-testing)

### Integration Testing
[Integration Tests](./TEST_GUIDE.md#integration-testing)

### End-to-End Testing
[end-to-end Tests](./TEST_GUIDE.md#end-to-end-testing)

### Linting and Formatting
The CI build will fail on lint issues. Run `make lint` to ensure your code is meetings formatting and linting requirements.

### Generating terraform docs
The Inputs and Outputs sections in the READMEs of the root module, submodules, and example modules are automatically generated based on the `variables` and `outputs` of the respective modules. These tables must be refreshed if the module interfaces are changed.

Run `make generate-readme` to generate the READMEs for the root module, submodules, and example modules.