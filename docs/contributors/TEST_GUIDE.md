# Testing Guide
This doc explains the testing guide for the project when contributing to the codebase. It should serve as a reference for all contributors, and be useful especially to new and infrequent submitters.


<!-- TOC -->
- [Unit Testing](#unit-testing)
- [Integration Testing](#integration-testing)
- [Test Environment](#test-environment)
  * [Noninteractive Execution](#noninteractive-execution)
  * [Interactive Execution](#interactive-execution)
- 
<!-- /TOC -->

## Unit Testing


## Integration Testing

Integration tests are used to verify the behaviour of the root module, submodules, and example modules. Additions, changes, and fixes should be accompanied by tests.

The integration tests are run using [Kitchen][kitchen], [Kitchen-Terraform][kitchen-terraform], and [InSpec][inspec]. These tools are packaged within a Docker image for convenience.

The general strategy for these tests is to verify the behaviour of the [example modules](../../examples), thus ensuring that the root module, submodules, and example modules are all functionally correct.

## Test Environment

The easiest way to test the module is in an isolated test project and folder.
The setup for such a project and folder is defined in [test/setup](../../test/setup) directory.
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


## End-to-end testing

<!-- 
ToDo: verify delete testing covered
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
-->