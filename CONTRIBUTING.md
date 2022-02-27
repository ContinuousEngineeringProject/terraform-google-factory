# Contribute to Continuous Engineering Factory GKE Module
Want to hack on the Continuous Engineering Factory GKE Module? Awesome! This page contains information that will help you contribute to the project.

- [Contribution workflow](#Contribution-workflow)
    * [How to contribute](#How-to-contribute) ??????
    * [Open a pull request](#Open-a-pull-request)
    * [Getting a pull request merged](#Getting-a-pull-request-merged)
- [Testing](#Testing)
    * ??

## Dependencies

The following dependencies must be installed on the development system:

- [Docker Engine][docker-engine]
- [Google Cloud SDK][google-cloud-sdk]
- [make]

### File structure 
The project has the following folders and files:

<!-- ToDo: Update the file structure -->
- `/`: root folder
- `/examples`: examples for using this module
- `/scripts`: Scripts for specific tasks on module (see Infrastructure section on this file)
- `/test`: Folders with files for testing the module (see [Testing section](#testing) on this file)
- `/helpers`: Optional helper scripts for ease of use
- `/main.tf`: main file for this module, contains all the resources to create
- `/variables.tf`: all the variables for the module
- `/output.tf`: the outputs of the module
- `/README.md`: this file



## Contribution workflow
<!-- ToDo: Simplify Contribution Workflow -->

?????

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

Integration tests are used to verify the behaviour of the root module,
submodules, and example modules. Additions, changes, and fixes should
be accompanied with tests.

The integration tests are run using [Kitchen][kitchen],
[Kitchen-Terraform][kitchen-terraform], and [InSpec][inspec]. These
tools are packaged within a Docker image for convenience.

The general strategy for these tests is to verify the behaviour of the
[example modules](./examples/), thus ensuring that the root module,
submodules, and example modules are all functionally correct.

### Test Environment

The easiest way to test the module is in an isolated test project and folder.
The setup for such a project and folder is defined in [test/setup](./test/setup/) directory.
This setup will create a dedicated folder, a project within the folder to hold a service
account that will be used to run the integration tests. It will assign all needed roles
to the service account and will also create a access context manager policy needed for test execution.

To use and execute this setup, you need a service account with the following roles:

- Project Creator access on the folder (if you want to delete the setup later ProjectDeleter is also needed).
- Folder Admin on the folder.
- Access Context Manager Editor or Admin on the organization.
- Billing Account Administrator on the billing account or on the organization.
- Organization Administrator on the organization in order to grant the created service account permissions on organization level.

Export the Service Account credentials to your environment like so:

```bash
export SERVICE_ACCOUNT_JSON=$(< credentials.json)
```

You will also need to set a few environment variables:

```bash
export TF_VAR_org_id="your_org_id"
export TF_VAR_folder_id="your_folder_id"
export TF_VAR_billing_account="your_billing_account_id"
export TF_VAR_gsuite_admin_email="your_gsuite_admin_email"
export TF_VAR_gsuite_domain="your_gsuite_domain"
```

With these settings in place, you can prepare the test setup using Docker:

```bash
make docker_test_prepare
```

### Noninteractive Execution

Run `make docker_test_integration` to test all of the example modules
noninteractively, using the prepared test project.

### Interactive Execution

1. Run `make docker_run` to start the testing Docker container in
   interactive mode.

1. Run `kitchen_do create <EXAMPLE_NAME>` to initialize the working
   directory for an example module.

1. Run `kitchen_do converge <EXAMPLE_NAME>` to apply the example module.

1. Run `kitchen_do verify <EXAMPLE_NAME>` to test the example module.

1. Run `kitchen_do destroy <EXAMPLE_NAME>` to destroy the example module
   state.

## Linting and Formatting

The CI build will fail on lint issues. To format and run locally execute `make lint`.

### Execution

Run `make docker_test_lint`.

## Releasing New Versions

New versions can be released by pushing tags to this repository's origin on
GitHub. There is a Make target to facilitate the process:

```bash
make release-new-version
```

The new version must be documented in [CHANGELOG.md](CHANGELOG.md) for the
target to work.

See the Terraform documentation for more info on [releasing new
versions][release-new-version].

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

---------------------------------------------------------------------------------------------------

Two test-kitchen instances are defined:

- `full-local` - Test coverage for all project-factory features.
- `full-minimal` - Test coverage for a minimal set of project-factory features.

### Setup

1. Configure the [test fixtures](#test-configuration).
2. Download a Service Account key with the necessary [permissions](#permissions)
   and put it in the module's root directory with the name `credentials.json`.
3. Add appropriate variables to your environment

   ```bash
   export BILLING_ACCOUNT_ID="YOUR_BILLUNG_ACCOUNT"
   export DOMAIN="YOUR_DOMAIN"
   export FOLDER_ID="YOUR_FOLDER_ID"
   export GROUP_NAME="YOUR_GROUP_NAME"
   export ADMIN_ACCOUNT_EMAIL="YOUR_ADMIN_ACCOUNT_EMAIL"
   export ORG_ID="YOUR_ORG_ID"
   export PROJECT_ID="YOUR_PROJECT_ID"
   CREDENTIALS_FILE="credentials.json"
   export SERVICE_ACCOUNT_JSON=`cat ${CREDENTIALS_FILE}`
   ```

4. Run the testing container in interactive mode.

    ```bash
    make docker_run
    ```

    The module root directory will be loaded into the Docker container at `/cft/workdir/`.
5. Run kitchen-terraform to test the infrastructure.

    1. `kitchen create` creates Terraform state.
    2. `kitchen converge` creates the underlying resources. You can run `kitchen converge minimal` to only create the minimal fixture.
    3. `kitchen verify` tests the created infrastructure. Run `kitchen verify minimal` to run the smaller test suite.
    4. `kitchen destroy` removes the created infrastructure. Run `kitchen destroy minimal` to remove the smaller test suite.

Alternatively, you can simply run `make test_integration_docker` to run all the
test steps non-interactively.

#### Test configuration

Each test-kitchen instance is configured with a `terraform.tfvars` file in the
test fixture directory. For convenience, these are symlinked to a single shared file:

```sh
cp "test/fixtures/shared/terraform.tfvars.example" \
  "test/fixtures/shared/terraform.tfvars"
$EDITOR "test/fixtures/shared/terraform.tfvars"
done
```

Integration tests can be run within a pre-configured docker container. Tests can
be run without user interaction for quick validation, or with user interaction
during development.


## Generating terraform docs for the readme
If you add or remove any terraform input or outputs you will need to regenerate the docs and update the README.md sections

```
make markdown-table
```
## Generating Documentation for Inputs and Outputs
The Inputs and Outputs tables in the READMEs of the root module,
submodules, and example modules are automatically generated based on
the `variables` and `outputs` of the respective modules. These tables
must be refreshed if the module interfaces are changed.

### Execution

Run `make generate_docs` to generate new Inputs and Outputs tables.


[REVIEWING]: ./docs/contributors/REVIEWING.md