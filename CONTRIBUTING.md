# Contribute to Continuous Engineering Factory GKE Module
Want to hack on the Continuous Engineering Factory GKE Module? Awesome! This page contains information that will help you contribute to the project.

- [Contribution workflow](#Contribution-workflow)
    * [Push commits](#Push-commits)
    * [Build your change](#Build-your-change)
    * [Squash and rebase](#Squash-and-rebase)
    * [Signoff](#Signoff)
    * [Commit message guidelines](#Commit-message-guidelines)
    * [Open a pull request](#Open-a-pull-request)
    * [Getting a pull request merged](#Getting-a-pull-request-merged)
- [Testing](#Testing)
    * [Writing tests](#Writing-tests)
    * [What is an unencapsulated test](#What-is-an-unencapsulated-test)
    * [Mocking and Stubbing](#Mocking-and-stubbing)
    

## Contribution workflow

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

This is a bit more advanced but required to ensure a proper Git history of Continuous Engineering Factory GKE Module. Git allows you to [rebase](https://git-scm.com/docs/git-rebase) commits. In other words: it allows you to rewrite the commit history.

Let's take an example.

```sh
git rebase --interactive @~3
```

The `3` at the end of the command represents the number of commits that should be modified. An editor should open and present a list of last three commit messages:

```sh
pick 911c35b Add "How to contribute to Continuous Engineering Factory GKE Module" tutorial
pick 33c8973 Begin workflow
pick 3502f2e Refactoring and typo fixes
```

In the case above we should merge the last 2 commits in the commit of this tutorial (`Add "How to contribute to Continuous Engineering Factory GKE Module" tutorial`). You can "squash" commits, i.e. merge two or more commits into a single one.

All operations are written before the commit message. Replace `pick` with an operation. In this case `squash` or `s` for short:

```sh
pick 911c35b Add "How to contribute to Continuous Engineering Factory GKE Module" tutorial
squash 33c8973 Begin workflow
squash 3502f2e Refactoring and typo fixes
```

We also want to rewrite the commits message of the third last commit. We forgot "docs:" as prefix according to the code contribution guidelines. The operation to rewrite a commit is called `reword` (or `r` as shortcut).

You should end up with a similar setup:

```sh
reword 911c35b Add "How to contribute to Continuous Engineering Factory GKE Module" tutorial
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

Continuous Engineering Factory GKE Module enforces the DCO using the a [bot](https://github.com/probot/dco). You can view the details on the DCO check by viewing the `Checks` tab in the GitHub pull request.

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
   
### Commit message guidelines
Continuous Engineering Factory GKE Module uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) as it's commit message format. These are particularly important as semantic releases are in use, and they use the commit messages to determine the type of changes in the codebase. Following formalized conventions for commit messages the semantic release automatically determines the next [semantic version](https://semver.org) number and generates a changelog based on the conventional commit.

Semantic releases originate in the [Angular Commit Message Conventions](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines), and the rules described there are the ones used by Continuous Engineering Factory GKE Module

Here is an example of the release type that will be done based on a commit messages:

| Commit message | Release type |
|---|---|
| `fix(pencil): stop graphite breaking when too much pressure applied` | Patch Release |
| `feat(pencil): add 'graphiteWidth' option` | ~~Minor~~ Feature Release  |
| `perf(pencil): remove graphiteWidth option`<br><br>`BREAKING CHANGE: The graphiteWidth option has been removed.`<br>`The default graphite width of 10mm is always used for performance reasons.` | ~~Major~~ Breaking Release |

#### Commit message format
Each commit message consists of a **header**, a **body** and a **footer**.  The header has a special
format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line of the commit message cannot be longer 100 characters! This allows the message to be easier
to read on GitHub as well as in various git tools.

#### Revert
If the commit reverts a previous commit, it should begin with `revert: `, followed by the header of the reverted commit. In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit being reverted.

#### Type
Must be one of the following:

 - **build**: Changes that affect the build system or external dependencies 
 - **chore**: Changes that will not affect production code
 - **ci**: Changes to our CI configuration files and scripts 
 - **docs**: Documentation only changes
 - **feat**: A new feature
 - **fix**: A bug fix
 - **perf**: A code change that improves performance
 - **refactor**: A code change that neither fixes a bug nor adds a feature
 - **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
 - **test**: Adding tests or correcting existing tests

#### Scope
The scope should be the name of the package affected (as perceived by the person reading the changelog generated from commit messages).

#### Subject
The subject contains a succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize the first letter
* no dot (.) at the end

#### Body
Just as in the **subject**, use the imperative, present tense: "change" not "changed" nor "changes".
The body should include the motivation for the change and contrast this with previous behavior.

#### Footer
The footer should contain any information about **Breaking Changes** and is also the place to
reference the issue(s) that this commit **Closes**.

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space or two newlines. The rest of the commit message is then used for this.

### Open a pull request
We made a lot of progress. Good work. In this step we finally open a pull request to submit our additions. Open the [Continuous Engineering Factory GKE Module master repository](https://github.com/continuousengineeringproject/terraform-google-factory/) on GitHub in your browser.

You should find a green button labeled with "New pull request". But GitHub is clever and probably suggests you a pull request in a beige box.

The new page summaries the most important information of your pull request. Scroll down, and you will find the additions of all your commits. Make sure everything looks as expected and click on "Create pull request".

There are a number of automated checks that will run on your PR:

* Semantic Pull Request - validates that your commit messages meet the Conventional Commit format described above, additionally your PR must also have a conventional message. The UX for this bot is a little odd as it doesn't go red if the messages are NOT correct, instead it goes yellow. You need it to go to a green tick!
* DCO - see [Signoff](#signoff)
* Hound - lints the code and comments inline with any issues. You need this to go to a green tick and say "No violations found. Woof!"
* lint - runs a lot more lint checks but in a CI job so won't provide inline feedback. You need this to pass as a green tick. Check the log for any errors.
* tekton - runs the end to end tests in a new cluster using tekton. Check the logs for errors.
* integration - runs all the tests that are inline in the codebase. Check the logs for errors.
* tide - performs the merge when all the checks pass. Don't worry about the state of this one, it doesn't add much info. Clicking on the details link is very helpful as it will take you to the dashboard where you can navigate to the "Tide" screen and check the status of your PR in the merge queue.

Then the maintainers will review your PR, potentially initiate discussion around your change and finally, merge it successfully in Continuous Engineering Factory GKE Module. Congratulations !

### Getting a pull request merged
Now your pull request is submitted, you need to get it merged. If you aren't a regular contributor you'll need a maintainer to manually review your PR and issue a `/ok-to-test` command in a PR comment. This will trigger the automated tests. If the tests fail, you'll need to ask one of the maintainers to send you the failure log (in the future we will make these public but first we need to check we are masking all secrets).

If the tests pass you need to get a `/lgtm` from one of the reviewers (listed in the `OWNERS` file in the repository). You need a new LGTM every time you push changes. Once the tests pass, and you have a LGTM for the latest changeset, your PR will be automatically merged.

Jenkins X (well, Tide, a component of Jenkins X) won't merge your changes until it has the tests passing against the *current* `HEAD` of `master` - but don't worry, whilst the tests *continue* to pass it will automatically merge your changeset into master and rerun the tests. As you can imagine, this can take a little while if the merge queue is long. Tide will also automatically attempt to batch up passing changes, but if the batch fails, it will resort to merging the changesets one by one.

If the retest against `HEAD` of `master` fail, then it will notify you on the pull request, and you'll need to make some changes (and potentially get a new LGTM).

For an explanation of the review and approval process see the [REVIEWING][REVIEWING] page.


## Testing
The test suite is divided into three sections:
 - The standard unit test suite
 - Slow unit tests
 - Integration tests

To run the standard test suite:
```sh
make test
```

To run focused tests:
```sh
make test-focus
```


## Linting
The CI build will fail on lint issues.  To format and run locally execute `make lint`.

Helpful tip if using an IDE like intelij you can enable file watchers and auto format terraform files.

## Generating terraform docs for the readme
If you add or remove any terraform input or outputs you will need to regenerate the docs and update the README.md sections

```
make markdown-table
```

[REVIEWING]: ./docs/contributors/REVIEWING.md