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

- [Git](https://git-scm.com/) and a [GitHub](https://github.com/) account. Details on [configuring Git](docs/contributors/GIT_CONFIG.md/#Git-Configuration) for the project.
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

Alternatively, you can export the environment variable _GOOGLE_APPLICATION_CREDENTIALS_ referencing the path to a Google Cloud [service account key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

Last but not least, ensure you have the following binaries installed:

- `gcloud`
- `kubectl` ~> 1.14.0
    - `kubectl` comes bundled with the Cloud SDK
- `terraform` ~> 0.12.0
    - Terraform installation instruction can be found [here](https://learn.hashicorp.com/terraform/getting-started/install)
    