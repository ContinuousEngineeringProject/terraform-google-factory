# :project

<!-- TODO: Replace all placeholders in the project
:project
:repo
:binary
:BINARY
:GoVersion
-->

<!-- TODO: Update project description -->
The :project is an open-source package created as part of the Continuous Engineering Project. The Continuous Engineering Project is an open framework that enables continuous engineering best practices through plug & play toolsets.

[![License](https://img.shields.io/github/license/ContinuousEngineeringProject/:repo)](https://github.com/ContinuousEngineeringProject/:repo/blob/master/LICENSE)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![DepShield Badge](https://depshield.sonatype.org/badges/ContinuousEngineeringProject/:repo/depshield.svg)](https://depshield.github.io)
[![GoReport](https://goreportcard.com/badge/github.com/ContinuousEngineeringProject/:repo)](https://goreportcard.com/report/github.com/ContinuousEngineeringProject/:repo)
[![GoDoc](https://godoc.org/github.com/ContinuousEngineeringProject/:repo?status.svg)](https://godoc.org/github.com/ContinuousEngineeringProject/:repo)
[![GitHub release](https://img.shields.io/github/v/release/ContinuousEngineeringProject/:repo?include_prereleases)](https://github.com/ContinuousEngineeringProject/:repo/releases/latest)
[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://continuousengproject.slack.com)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=ContinuousEngineeringProject_:repo&metric=alert_status)](https://sonarcloud.io/dashboard?id=ContinuousEngineeringProject_:repo)

## Installation

Pick the most suitable instructions for your operating system:

### macOS

1. Download the `:binary` binary archive using `curl` and pipe (`|`) the compressed archive to
   the `tar` command:
   
   ```sh
   curl -L https://github.com/continuousengineeringproject/:repo/releases/latest/download/:repo-darwin-amd64.tar.gz | tar xzv 
    ```

1. Install the `:binary` binary by moving it to a location in your executable path using the `mv` command:

   ```sh
   sudo mv :binary /usr/local/bin
    ```

1. Run `:binary version --short` to make sure you're on the latest stable version

   ```sh
   :binary version --short
   ```

### Linux

1. Download the `:binary` binary archive using `curl` and pipe (`|`) the compressed archive to
   the `tar` command:

   ```sh
   curl -L https://github.com/continuousengineeringproject/:repo/releases/latest/download/:repo-linux-amd64.tar.gz | tar xzv 
    ```

1. Install the `:binary` binary by moving it to a location in your executable path using the `mv` command:

   ```sh
   sudo mv :binary /usr/local/bin
    ```

1. Run `:binary version --short` to make sure you're on the latest stable version

   ```sh
   :binary version --short
   ```
   
<!-- TODO: Add project usage
## Usage

Use examples liberally, and show the expected output if you can. It's helpful to have inline the smallest example of usage that you can demonstrate, while providing links to more sophisticated examples if they are too long to reasonably include in the README.

```go

```
-->

<!-- TODO: Add link to the roadmap in the project knowledge base.
## Roadmap

If you have ideas for releases in the future, it is a good idea to list them here.
-->


## Contributing

Read [CONTRIBUTING.md][CONTRIB] for details of all the ways you can contribute to the project.

Also read [CODE_OF_CONDUCT.md][COC] for details on our code of conduct for the project.


## Versioning

We use [SemVer][SEMVER] for versioning. For the versions available, see the [tags on this repository][REPOTAGS].


## License

Licensed under the MIT license - see the [LICENSE][LICENSE] file for details.


[LICENSE]: LICENSE
[SEMVER]: http://semver.org/
[COC]: CODE_OF_CONDUCT.md
[CONTRIB]: CONTRIBUTING.md
[REPOTAGS]: https://github.com/continuousengineeringproject/:repo/tags