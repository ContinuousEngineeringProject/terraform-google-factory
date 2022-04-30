# Continuous Engineering Factory GKE Module

[![License](https://img.shields.io/github/license/ContinuousEngineeringProject/terraform-google-factory)](https://github.com/ContinuousEngineeringProject/terraform-google-factory/blob/master/LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![DepShield Badge](https://depshield.sonatype.org/badges/ContinuousEngineeringProject/terraform-google-factory/depshield.svg)](https://depshield.github.io)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![GitHub release](https://img.shields.io/github/v/release/ContinuousEngineeringProject/terraform-google-factory?include_prereleases)](https://github.com/ContinuousEngineeringProject/terraform-google-factory/releases/latest)
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://continuousengproject.slack.com)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ContinuousEngineeringProject_terraform-google-factory&metric=alert_status)](https://sonarcloud.io/dashboard?id=ContinuousEngineeringProject_terraform-google-factory)

---
[FAQ](/docs/contributors/FAQ.md) | [Troubleshooting Guide](/docs/contributors/TROUBLESHOOTING.md) | [Glossary](/docs/contributors/GLOSSARY.md)

This repository contains a [Terraform](https://www.terraform.io/) module for provisioning the Continuous Engineering Factory on [Google Cloud](https://cloud.google.com/).

<!-- TOC -->
- [Compatibility](#compatibility)
- [Usage](#usage)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Caveats](#caveats)
- [Contributing](#contributing)
- [Versioning](#versioning)
- [License](#license)
<!-- /TOC -->

## Compatibility
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+. If you find incompatibilities using Terraform >=0.13, please open an issue.

## Usage
There are multiple examples included in the [examples](../examples) folder but a simple usage is as follows:

```hcl
module "factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 10.1"

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

## Caveats

## Contributing

Read [CONTRIBUTING.md][CONTRIB] for details of all the ways you can contribute to the project.

Also read [CODE\_OF\_CONDUCT.md][COC] for details on our code of conduct for the project.

## Versioning

We use [SemVer][SEMVER] for versioning. For the versions available, see the [tags on this repository][REPOTAGS].

## License

Licensed under the MIT license - see the [LICENSE][LICENSE] file for details.

[LICENSE]: ../LICENSE
[SEMVER]: http://semver.org/
[COC]: ../CODE\_OF\_CONDUCT.md
[CONTRIB]: ../CONTRIBUTING.md
[REPOTAGS]: https://github.com/continuousengineeringproject/terraform-google-factory/tags
