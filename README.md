<!-- BEGIN_TF_DOCS -->
# Continuous Engineering Factory GKE Module

[![License](https://img.shields.io/github/license/ContinuousEngineeringProject/terraform-google-factory)](https://github.com/ContinuousEngineeringProject/terraform-google-factory/blob/master/LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![DepShield Badge](https://depshield.sonatype.org/badges/ContinuousEngineeringProject/terraform-google-factory/depshield.svg)](https://depshield.github.io)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.12.0-blue.svg)
[![GitHub release](https://img.shields.io/github/v/release/ContinuousEngineeringProject/terraform-google-factory?include_prereleases)](https://github.com/ContinuousEngineeringProject/terraform-google-factory/releases/latest)
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://continuousengproject.slack.com)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ContinuousEngineeringProject_terraform-google-factory&metric=alert_status)](https://sonarcloud.io/dashboard?id=ContinuousEngineeringProject_terraform-google-factory)

---

This repo contains a [Terraform](https://www.terraform.io/) module for provisioning the Continuous Engineering Factory on [Google Cloud](https://cloud.google.com/).

<!-- TOC -->

- [What is a Terraform module](#what-is-a-terraform-module)
- [How do you use this module](#how-do-you-use-this-module)
    - [Prerequisites](#prerequisites)
    - [Inputs](#inputs)
    - [Outputs](#outputs)
    - [Using a custom domain](#using-a-custom-domain)
    - [Configuring a Terraform backend](#configuring-a-terraform-backend)
- [FAQ](#faq)
    - [How do I get the latest version of the terraform-google-factory module](#how-do-i-get-the-latest-version-of-the-terraform-google-factory-module)
    - [How to I specify a specific google provider version](#how-to-i-specify-a-specific-google-provider-version)
    - [Why do I need Application Default Credentials](#why-do-i-need-application-default-credentials)
- [Development](#development)
    - [Releasing](#releasing)
- [Contributing](#contributing)
- [Versioning](#versioning)
- [License](#license)

<!-- /TOC -->

## What is a Terraform module

A Terraform "module" refers to a self-contained package of Terraform configurations that are managed as a group.
For more information around modules refer to the Terraform [documentation](https://www.terraform.io/docs/modules/index.html).

## How do you use this module

### Prerequisites

<!-- ToDo: Update this section with the appropriate prerequisites -->

- [Git](https://git-scm.com/) and a [GitHub](https://github.com/) account. Details on [configuring Git](docs/contributors/GIT\_CONFIG.md/#Git-Configuration) for the project.
- [terraform-docs](https://terraform-docs.io) - for OSX `brew install terraform-docs`

To make use of this module, you need a Google Cloud project.
Instructions on how to setup such a project can be found in the  [Google Cloud Installation and Setup](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup) guide.
You need your Google Cloud project id as an input variable for using this module.

You also need to install the Cloud SDK, in particular `gcloud`.
You find instructions on how to install and authenticate in the [Google Cloud Installation and Setup](https://cloud.google.com/deployment-manager/docs/step-by-step-guide/installation-and-setup) guide as well.

Once you have `gcloud` installed, you need to create [Application Default Credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/login) by running:

```bash
gcloud auth application-default login
```

Alternatively, you can export the environment variable _GOOGLE\_APPLICATION\_CREDENTIALS_ referencing the path to a Google Cloud [service account key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

Last but not least, ensure you have the following binaries installed:

- `gcloud`
- `kubectl` ~> 1.14.0
    - `kubectl` comes bundled with the Cloud SDK
- `terraform` ~> 0.12.0
    - Terraform installation instruction can be found [here](https://learn.hashicorp.com/terraform/getting-started/install)
    

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_project"></a> [gcp\_project](#input\_gcp\_project) | The name of the GCP project to use | `string` | n/a | yes |

## Outputs

No outputs.

## Using a custom domain

If you want to use a custom domain with your Jenkins X installation, you need to provide values for the [variables](#inputs) _apex\\_domain_ and \_tls\\_email\_.
\_apex\\_domain\_ is the fully qualified domain name you want to use and _tls\\_email_ is the email address you want to use for issuing Let's Encrypt TLS certificates.

Before you apply the Terraform configuration, you also need to create a [Cloud DNS managed zone](https://cloud.google.com/dns/zones), with the DNS name in the managed zone matching your custom domain name, for example in the case of _example.jenkins-x.rocks_ as domain:

![Creating a Managed Zone](./images/create\_managed\_zone.png)

When creating the managed zone, a set of DNS servers get created which you need to specify in the DNS settings of your DNS registrar.

![DNS settings of Managed Zone](./images/managed\_zone\_details.png)

It is essential that before you run `jx boot`, your DNS servers settings are propagated, and your domain resolves.
You can use [DNS checker](https://dnschecker.org/) to check whether your domain settings have propagated.

When a custom domain is provided, Jenkins X uses [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) together with [cert-manager](https://github.com/jetstack/cert-manager) to create A record entries in your managed zone for the various exposed applications.

If _apex\_domain_ id not set, your cluster will use [nip.io](https://nip.io/) in order to create publicly resolvable URLs of the form ht<span>tp://\<app-name\>-\<environment-name\>.\<cluster-ip\>.nip.io.

## Configuring a Terraform backend

A "[backend](https://www.terraform.io/docs/backends/index.html)" in Terraform determines how state is loaded and how an operation such as _apply_ is executed.
By default, Terraform uses the _local_ backend which keeps the state of the created resources on the local file system.
This is problematic since sensitive information will be stored on disk, and it is not possible to share state across a team.
When working with Google Cloud a good choice for your Terraform backend is the [\_gcs\_ backend](https://www.terraform.io/docs/backends/types/gcs.html)  which stores the Terraform state in a Google Cloud Storage bucket.
The [examples](./examples) directory of this repository contains configuration examples for using the gcs backed with and without optionally configured customer supplied encryption key.

To use the gcs backend you will need to create the bucket upfront.
You can use `gsutil` to create the bucket:

```sh
gsutil mb gs://<my-bucket-name>/
```

It is also recommended to enable versioning on the bucket as an additional safety net in case of state corruption.

```sh
gsutil versioning set on gs://<my-bucket-name>
```

You can verify whether a bucket has versioning enabled via:

```sh
gsutil versioning get gs://<my-bucket-name>
```

## FAQ

### How do I get the latest version of the terraform-google-factory module

```sh
terraform init -upgrade
```

### How to I specify a specific google provider version

```yaml
provider "google" {
  version = "~> 2.12.0"
  project = var.gcp_project
}

provider "google-beta" {
  version = "~> 2.12.0"
  project = var.gcp_project
}
```

### Why do I need Application Default Credentials

The recommended way to authenticate to the Google Cloud API is by using a [service account](https://cloud.google.com/docs/authentication/getting-started).
This allows for authentication regardless of where your code runs.
This Terraform module expects authentication via a service account key.
You can either specify the path to this key directly using the _GOOGLE\_APPLICATION\_CREDENTIALS_ environment variable or you can run `gcloud auth application-default login`.
In the latter case `gcloud` obtains user access credentials via a web flow and puts them in the well-known location for Application Default Credentials (ADC), usually \_~/.config/gcloud/application\_default\_credentials.json\_.

## Releasing

At the moment there is no release pipeline defined in [jenkins-x.yml](./jenkins-x.yml).
A Terraform release does not require building an artifact, only a tag needs to be created and pushed.
To make this task easier and there is a helper script `release.sh` which simplifies this process and creates the changelog as well:

```sh
./scripts/release.sh
```

This can be executed on demand whenever a release is required.
For the script to work the environment variable _$GH\_TOKEN_ must be exported and reference a valid GitHub API token.

## Contributing

Read [CONTRIBUTING.md][CONTRIB] for details of all the ways you can contribute to the project.

Also read [CODE\_OF\_CONDUCT.md][COC] for details on our code of conduct for the project.

## Versioning

We use [SemVer][SEMVER] for versioning. For the versions available, see the [tags on this repository][REPOTAGS].

## License

Licensed under the MIT license - see the [LICENSE][LICENSE] file for details.

[LICENSE]: LICENSE
[SEMVER]: http://semver.org/
[COC]: CODE\_OF\_CONDUCT.md
[CONTRIB]: CONTRIBUTING.md
[REPOTAGS]: https://github.com/continuousengineeringproject/terraform-google-factory/tags
<!-- END_TF_DOCS -->