# Contribute to :project
Want to hack on the :project? Awesome! This page contains information that will help you set up a development environment for working on the source code.

- [Prerequisites](#Prerequisites)
- [Contribution workflow](#Contribution-workflow)
    * [Cross platform development](#Cross-platform-development)
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
    

## Prerequisites
To compile, test and contribute towards the project binaries you will need:

 - [Git](https://git-scm.com/) and a [GitHub](https://github.com/) account. Details on [configuring Git](docs/contributors/GIT_CONFIG.md/#Git-Configuration) for the project.
 - [Go](https://golang.org/) :GoVersion with support for compiling to `linux/amd64`. Details on [configuring Go](docs/contributors/GO_CONFIG.md/#Go-Configuration) for the project.


In most cases, install the prerequisite according to its instructions. See the next section for a note about [Go cross-compiling](#Cross platform development) support.


## Contribution workflow

### Create a new branch
First, ensure that your local repository is up-to-date with the latest version of :repo. More details on [GitHub help](https://help.github.com/articles/syncing-a-fork/).

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

### Cross platform development
Bear in mind when developing that the code can (and will) run on different architectures/operating systems from your own. You may develop on a *nix platform, but other users will also be using Windows. Keep other platforms in mind when developing your code, eg:

* Not all platforms use the `HOME` environment variable for your home directory. Use [`user.Current`](https://golang.org/pkg/os/user/#Current) [`.HomeDir`](https://golang.org/pkg/os/user/#User) instead of looking up `$HOME` to get the user's home directory
* Different platforms use different places for temporary directories/files. Use [`ioutil.TempDir`](https://golang.org/pkg/io/ioutil/#TempDir) instead of creating directories/files under `/tmp`
* Be aware of path separators (*nix uses `/`, Windows uses `\`) - do not just concatenate strings when using filepaths; instead use [`filepath.Join`](https://golang.org/pkg/path/filepath/#Join) to concatenate file paths safely
* Be aware of default line endings (*nix uses `LF`, Windows uses `CRLF`)

### Push commits
To push our commits to the fork on GitHub you need to specify a destination. A destination is defined by the remote, and a branch name. Earlier, the remote url of our fork was given the default name of `origin`. The branch should be given the same name as our local one. This makes it easy to identify corresponding branches.

```sh
git push --set-upstream origin <BRANCH-NAME>
```

Now Git knows the destination. Next time when you want to push commits you just need to enter `git push`.

### Build your change
With the prerequisites installed and your fork of :project cloned, you can make changes to local :project source code and hack as much as you want.

Run `make` to build the :binary binaries:

```sh
make build
```

See below to get some advises on how to [test](#testing).

### Squash and rebase
So you are happy with your development and are ready to prepare the PR. Before going further, let's squash and rebase your work.

This is a bit more advanced but required to ensure a proper Git history of :project. Git allows you to [rebase](https://git-scm.com/docs/git-rebase) commits. In other words: it allows you to rewrite the commit history.

Let's take an example.

```sh
git rebase --interactive @~3
```

The `3` at the end of the command represents the number of commits that should be modified. An editor should open and present a list of last three commit messages:

```sh
pick 911c35b Add "How to contribute to :project" tutorial
pick 33c8973 Begin workflow
pick 3502f2e Refactoring and typo fixes
```

In the case above we should merge the last 2 commits in the commit of this tutorial (`Add "How to contribute to :project" tutorial`). You can "squash" commits, i.e. merge two or more commits into a single one.

All operations are written before the commit message. Replace `pick` with an operation. In this case `squash` or `s` for short:

```sh
pick 911c35b Add "How to contribute to :project" tutorial
squash 33c8973 Begin workflow
squash 3502f2e Refactoring and typo fixes
```

We also want to rewrite the commits message of the third last commit. We forgot "docs:" as prefix according to the code contribution guidelines. The operation to rewrite a commit is called `reword` (or `r` as shortcut).

You should end up with a similar setup:

```sh
reword 911c35b Add "How to contribute to :project" tutorial
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

:project enforces the DCO using the a [bot](https://github.com/probot/dco). You can view the details on the DCO check by viewing the `Checks` tab in the GitHub pull request.

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
:project uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) as it's commit message format. These are particularly important as semantic releases are in use, and they use the commit messages to determine the type of changes in the codebase. Following formalized conventions for commit messages the semantic release automatically determines the next [semantic version](https://semver.org) number and generates a changelog based on the conventional commit.

Semantic releases originate in the [Angular Commit Message Conventions](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines), and the rules described there are the ones used by :project

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
We made a lot of progress. Good work. In this step we finally open a pull request to submit our additions. Open the [:project master repository](https://github.com/continuousengineeringproject/:repo/) on GitHub in your browser.

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

Then the maintainers will review your PR, potentially initiate discussion around your change and finally, merge it successfully in :project. Congratulations !

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

To run the standard test suite including slow running tests:
```sh
make test-slow
```

To run all tests including integration tests (NOTE These tests are not encapsulated):
```sh
make test-slow-integration
```

To get a nice HTML report on the tests:
```sh
make test-report-html
```

### Writing tests
The project uses standard `go test` and [testify][TESTIFY] assertions and are located in the package they test. For information on Go's test framework, see [Go's testing package documentation][TESTING] and the [go test help][GOTESTHELP].

#### Unit tests
Unit tests should be isolated (see below section [What is an unencapsulated test?](#what-is-an-unencapsulated-test)), and should contain the `t.Parallel()` directive in order to keep things nice and speedy.

If you add a slow running (more than a couple of seconds) test, it needs to be wrapped like so:
```golang
if testing.Short() {
	t.Skip("skipping a_long_running_test")
} else {
	// Slow test goes here...
}
```
Slow tests can (and should) still include `t.Parallel()`.

Best practice for unit tests is to define the testing package appending _test to the name of your package, e.g. `mypackage_test` and then import `mypackage` inside your tests. This encourages good package design and will enable you to define the exported package API in a composable way.

#### Integration tests
To add an integration test, create a separate file for your integration tests using the naming convention `mypackage_integration_test.go` Use the same package declaration as your unit tests: `mypackage_test`. At the very top of the file before the package declaration add this custom build directive:

```golang
// +build integration
```
Note that there needs to be a blank line before you declare the package name.

This directive will ensure that integration tests are automatically separated from unit tests, and will not be run as part of the normal test suite. You should **NOT** add `t.Parallel()` to an unencapsulated test as it may cause intermittent failures.

### What is an unencapsulated test
A test is unencapsulated (not isolated) if it cannot be run (with repeatable success) without a certain surrounding state. Relying on external binaries that may not be present, writing or reading from the filesystem without care to specifically avoid collisions, or relying on other tests to run in a specific sequence for your test to pass are all examples of a test that you should carefully consider before committing. If you would like to easily check that your test is isolated before committing simply run: `make docker-test`, or if your test is marked as slow: `make docker-test-slow`. This will mount the project folder into a golang docker container that does not include any of your host machines environment. If your test passes here, then you can be happy that the test is encapsulated.

### Mocking and stubbing
Mocking or stubbing methods in your unit tests will get you a long way towards test isolation. Coupled with the use of interface based APIs you should be able to make your methods easily testable and useful to other packages that may need to import them. [Pegomock](https://github.com/petergtz/pegomock) is our mocking library of choice, mainly because it is very easy to use and doesn't require you to write your own mocks (Yay!) We place all interfaces for each package in a file called `interface.go` in the relevant folder. So you can find all interfaces for `github.com/continuousengineeringproject/:repo/pkg/util` in `github.com/continuousengineeringproject/:repo/pkg/util/interface.go`. Generating/regenerating a mock for a given interface is easy, just go to the `interface.go` file that corresponds with the interface you would like to mock and add a comment directly above your interface definition that will look something like this:

```golang
// CommandInterface defines the interface for a Command
//go:generate pegomock generate github.com/continuousengineeringproject/:repo/pkg/util CommandInterface -o mocks/command_interface.go
type CommandInterface interface {
	DidError() bool
	DidFail() bool
	Error() error
	Run() (string, error)
	RunWithoutRetry() (string, error)
	SetName(string)
	SetDir(string)
	SetArgs([]string)
	SetTimeout(time.Duration)
	SetExponentialBackOff(*backoff.ExponentialBackOff)
}
```

In the example you can see that we pass the generator to use: `pegomock generate` the package path name: `github.com/continuousengineeringproject/:repo/pkg/util` the name of the interface: `CommandInterface` and finally an output directive to write the generated file to a mock sub-folder. To keep things nice and tidy it's best to write each mocked interface to a separate file in this folder. So in this case: `-o mocks/command_interface.go`

Now simply run:

```sh
go generate ./...
```

or

```sh
make generate-mocks
```

You now have a mock to test your new interface! The new mock can now be imported into your test file and used for easy mocking/stubbing. Here's an example:

```golang
package util_test

import (
	"errors"
	"testing"

	"github.com/continuousengineeringproject/:repo/pkg/util"
	mocks "github.com/continuousengineeringproject/:repo/pkg/util/mocks"
	. "github.com/petergtz/pegomock"
	"github.com/stretchr/testify/assert"
)

func Test:BINARYBinaryLocationSuccess(t *testing.T) {
	t.Parallel()
	commandInterface := mocks.NewMockCommandInterface()
	When(commandInterface.RunWithoutRetry()).ThenReturn("/test/something/bin/:binary", nil)

	res, err := util.:BIANRYBinaryLocation(commandInterface)
	assert.Equal(t, "/test/something/bin", res)
	assert.NoError(t, err, "Should not error")
}
```

Here we're importing the mock we need in our import declaration:

```golang
mocks "github.com/continuousengineeringproject/:repo/pkg/util/mocks"
```

Then inside the test we're instantiating `NewMockCommandInterface` which was automatically generated for us by pegomock.

Next we're stubbing something that we don't actually want to run when we execute our test. In this case we don't want to make a call to an external binary as that could break our tests isolation. We're using some handy matchers which are provided by pegomock, and importing using a `.` import to keep the syntax neat (You probably shouldn't do this outside of tests):

```golang
When(commandInterface.RunWithoutRetry()).ThenReturn("/test/something/bin/:binary", nil)
```

Now when we can set up our test using the mock interface and make assertions as normal.


[GOTESTHELP]: http://golang.org/cmd/go/#hdr-Test_packages
[TESTING]: https://golang.org/pkg/testing/
[REVIEWING]: ./docs/contributors/REVIEWING.md
[TESTIFY]: https://github.com/stretchr/testify