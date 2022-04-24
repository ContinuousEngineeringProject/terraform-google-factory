# Contribute to Continuous Engineering Factory GKE Module
Want to hack on the Continuous Engineering Factory GKE Module? Awesome! This page contains information that will help you contribute to the project.

<!-- TOC -->
- [Prerequisites](#prerequisites)
  * [Installation and authentication of the Cloud SDK](#installation-and-authentication-of-the-cloud-sdk)
  * 
- [Contribution workflow](#Contribution-workflow)
  * [Develop the change](#Develop-the-change)
    * [Supporting Tests](#supporting-tests)
    * [Pre-PR checks](#pre-pr-checks)
  * [Submit a pull request](#Submit-a-pull-request)

<!-- /TOC -->

## Prerequisites
The following prerequisites must be installed on your local development environment:

- `gcloud` ~>
  * Cloud SDK installation and authentication instructions in the can be found [here](#Installation-and-authentication-of-the-Cloud-SDK).
- `kubectl` ~> 1.14.0
  - `kubectl` comes bundled with the Cloud SDK
- `terraform` ~> 0.12.0
  - Terraform installation instruction can be found [here](https://learn.hashicorp.com/terraform/getting-started/install)
- `terraform-docs`
  * Terraform-docs installation instructions can be found [here](https://terraform-docs.io/user-guide/installation/).
- `docker`
  * Docker installation instructions can be found [here](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

### Installation and authentication of the Cloud SDK
You also need to install the Cloud SDK, in particular `gcloud`.
You find instructions on how to install and authenticate in the [Google Cloud Installation and Setup](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup) guide as well.

Once you have `gcloud` installed, you need to create [Application Default Credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login) by running:

```bash
gcloud auth application-default login
```

Alternatively, you can export the environment variable _GOOGLE\_APPLICATION\_CREDENTIALS_ referencing the path to a Google Cloud [service account key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).
## Contribution workflow
<!-- ToDo: Simplify Contribution Workflow -->

 - Develop the change.
 - Submit a pull request.

### Develop the change
<!-- ToDo: Add content -->
[Development Guide](./docs/contributors/DEV_GUIDE.md)

#### Supporting Tests
<!-- ToDo: Add content -->
[Test Guide](./docs/contributors/TEST_GUIDE.md)

- [Unit Tests](./docs/contributors/TEST_GUIDE.md#unit-testing)
- [Integration Tests](./docs/contributors/TEST_GUIDE.md#integration-testing)
- [end-to-end Tests](./docs/contributors/TEST_GUIDE.md#end-to-end-testing)
- [Linting and Formatting](./docs/contributors/DEV_GUIDE.md#Linting-and-Formatting)
- [Generating terraform docs](./docs/contributors/DEV_GUIDE.md#Generating-terraform-docs)

#### Pre-PR checks
Prior to submitting a pull request, you should execute `make pr-prep` to prepare the project for the pull request.:

- [Unit Tests](./docs/contributors/DEV_GUIDE.md#unit-testing)
- [Integration Tests](./docs/contributors/DEV_GUIDE.md#integration-testing)
- [end-to-end Tests](./docs/contributors/DEV_GUIDE.md#end-to-end-testing)
- [Linting and Formatting](./docs/contributors/DEV_GUIDE.md#Linting-and-Formatting)
- [Generating terraform docs](./docs/contributors/DEV_GUIDE.md#Generating-terraform-docs)

### Submit a pull request 
Now create a pull request for your change and submit it. Please review the [Pull Request Process](./PR_PROCESS.md) before submitting a pull request. 

There are a number of automated checks that will run on your PR:

- _Semantic Pull Request_
  * validates that your commit messages meet the Conventional Commit format described above, additionally your PR must also have a conventional message. The UX for this bot is a little odd as it doesn't go red if the messages are NOT correct, instead it goes yellow. You need it to go to a green tick!
- _DCO_ 
  * see [Signoff](./docs/contributors/DEV_GUIDE.md#signoff)
- _Hound_ 
  * lints the code and comments inline with any issues. You need this to go to a green tick and say "No violations found. Woof!"
- _lint_ 
  * runs a lot more lint checks but in a CI job so won't provide inline feedback. You need this to pass as a green tick. Check the log for any errors.
- _tekton_ 
  * runs the end-to-end tests in a new cluster using tekton. Check the logs for errors.
- _integration_
  * runs all the tests that are inline in the codebase. Check the logs for errors.
- _tide_ 
  * performs the merge when all the checks pass. Don't worry about the state of this one, it doesn't add much info. Clicking on the details link is very helpful as it will take you to the dashboard where you can navigate to the "Tide" screen and check the status of your PR in the merge queue.

Then the maintainers will review your PR, potentially initiate discussion around your change and finally, merge it successfully in the projects main branch. Congratulations !

#### Getting a pull request merged
Now your pull request is submitted, you need to get it merged. If you aren't a regular contributor you'll need a maintainer to manually review your PR and issue a `/ok-to-test` command in a PR comment. This will trigger the automated tests. If the tests fail, you'll need to ask one of the maintainers to send you the failure log (in the future we will make these public, but first we need to check we are masking all secrets).

If the tests pass you need to get a `/lgtm` from one of the reviewers (listed in the `OWNERS` file in the repository). You need a new LGTM every time you push changes. Once the tests pass, and you have a LGTM for the latest changeset, your PR will be automatically merged.

The factory (well, Tide, a component of Jenkins X) won't merge your changes until it has the tests passing against the *current* `HEAD` of `main` - but don't worry, whilst the tests *continue* to pass it will automatically merge your changeset into master or main and rerun the tests. As you can imagine, this can take a little while if the merge queue is long. Tide will also automatically attempt to batch up passing changes, but if the batch fails, it will resort to merging the changesets one by one.

If the retest against `HEAD` of `main` fail, then it will notify you on the pull request, and you'll need to make some changes (and potentially get a new LGTM).

For an explanation of the review and approval process see the [PR Process Guide][pr-guide] page.


[pr-guide]: ./docs/contributors/PR_GUIDE.md
[release-new-version]: https://www.terraform.io/docs/registry/modules/publish.html#releasing-new-versions
[docker-engine]: https://www.docker.com/products/docker-engine
[flake8]: http://flake8.pycqa.org/en/latest/
[gofmt]: https://golang.org/cmd/gofmt/
[google-cloud-sdk]: https://cloud.google.com/sdk/install
[hadolint]: https://github.com/hadolint/hadolint
[inspec]: https://inspec.io/
[kitchen-terraform]: https://github.com/newcontext-oss/kitchen-terraform
[kitchen]: https://kitchen.ci/
[make]: https://en.wikipedia.org/wiki/Make_(software)
[shellcheck]: https://www.shellcheck.net/
[terraform-docs]: https://github.com/segmentio/terraform-docs
[terraform]: https://terraform.io/

