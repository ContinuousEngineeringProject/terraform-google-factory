# Git Configuration
Useful information will help to configure Git for contributing to this project.

- [Install Git on your system](#Install-Git-on-your-system)
    * [Git graphical front ends](#Git-graphical-front-ends)
- [Create a GitHub account](#Create-a-GitHub-account)
- [Set up your working copy](#Set-up-your-working-copy)
  * [Fork the repository](#Fork-the-repository)
  * [Clone your fork locally](#Clone-your-fork-locally)
- [Pre commit hooks](#Pre-commit-hooks)


## Install Git on your system
Git is a [version control system](https://en.wikipedia.org/wiki/Version_control) to track the changes of source code.

You will need to have Git installed on your computer to contribute to :project development. Teaching Git is outside the scope of our docs, but if you're looking for an excellent reference to learn the basics of Git, we recommend the [Git book](https://git-scm.com/book/) if you are not sure where to begin.

Move back to the terminal and check if Git is already installed. Type in `git version` and press enter. You can skip the rest of this section if the command returned a version number. Otherwise [download](https://git-scm.com/downloads) the latest version and follow this [installation guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

Finally, check again with `git version` if Git was installed successfully.

### Git graphical front ends
There are several [GUI clients](https://git-scm.com/downloads/guis) that help you to operate Git. Not all are available for all operating systems and maybe differ in their usage. Thus, we will use the command line since the commands are everywhere the same.


## Create a GitHub account
If you're going to contribute code, you'll need to have an account on GitHub. Go to [www.github.com/join](https://github.com/join) and set up a personal account.


## Set up your working copy
The working copy is set up locally on your computer. It's what you'll edit, compile, and end up pushing back to GitHub. The main steps are cloning the repository and creating your fork as a remote.

### Fork the repository
If you're not familiar with this term, GitHub's [help pages](https://help.github.com/articles/fork-a-repo/) provide again a simple explanation:

> A fork is a copy of a repository. Forking a repository allows you to freely experiment with changes without affecting the original project.

Open the [:project repository](https://github.com/continuousengineeringproject/:repo) on GitHub and click on the "Fork" button in the top right.

### Clone your fork locally
Now open your fork repository on GitHub and copy the remote url of your fork. You can choose between HTTPS and SSH as protocol that Git should use for the following operations. HTTPS works always [if you're not sure](https://help.github.com/articles/which-remote-url-should-i-use/).

Then go back to your terminal and clone your fork locally. Since :project is a Go package, it should be located at `$GOPATH/src/github.com/continuousengineeringproject/:repo`.

```sh
mkdir -p $GOPATH/src/github.com/continuousengineeringproject
cd $GOPATH/src/github.com/continuousengineeringproject/:repo
git clone git@github.com:<YOUR_USERNAME>/:repo.git
cd :repo
```

Add the conventional upstream `git` remote in order to fetch changes from :repo's main master
branch and to create pull requests:

```sh
git remote add upstream https://github.com/continuousengineeringproject/:repo.git
```

Let's check if everything went right by listing all known remotes:

```sh
git remote -v
```

The output should look similar to:

```sh
origin    git@github.com:<YOUR_USERNAME>/:repo.git (fetch)
origin    git@github.com:<YOUR_USERNAME>/:repo.git (push)
upstream  https://github.com/continuousengineeringproject/:repo.git (fetch)
upstream  https://github.com/continuousengineeringproject/:repo.git (push)
```

## Pre commit hooks
These are installed as a git 'pre-commit' hook and it operates automatically via a hook when using the `git commit` command. To setup this hook:

- Install [pre-commit](https://pre-commit.com/#install)
- Once installed, ensure you're at the root repository which contains a `.pre-commit-config.yaml` configuration file, then :

```bash
pre-commit install
```

If you wish to find out more:
- [pre-commit](https://pre-commit.com)
- [git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
