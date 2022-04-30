# GCP factory project submodule
This module allows the creation of a factory project and selected services on GCP.

## Usage
Basic usage of this module is as follows:

```hcl
module "factory-project" {
  source  = "https://github.com/ContinuousEngineeringProject/terraform-google-factory"

  name                 = "pf-test-1"
  random_project_id    = true
  org_id               = "1234567890"
  usage_bucket_name    = "pf-test-1-usage-report-bucket"
  usage_bucket_prefix  = "pf/test/1/integration"
  billing_account      = "ABCDEF-ABCDEF-ABCDEF"
  svpc_host_project_id = "shared_vpc_host_name"

  shared_vpc_subnets = [
    "projects/base-project-196723/regions/us-east1/subnetworks/default",
    "projects/base-project-196723/regions/us-central1/subnetworks/default",
    "projects/base-project-196723/regions/us-central1/subnetworks/subnet-1",
  ]
}
```

<!-- BEGIN_TF_DOCS -->



<!-- END_TF_DOCS -->