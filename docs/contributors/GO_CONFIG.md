# Go Configuration
Useful information will help to configure Go for contributing to this project.

- [Install Go](#Install-Go)
    * [Install Go on macOS](#Install-Go-on-macOS)
    * [Install Go via GVM](#Install-Go-via-GVM)
    * [Install Go on Windows](#Install-Go-on-Windows)
- [Clearing your go module cache](#Clearing-your-go-module-cache)
- [Set up your GOPATH](#Set-up-your-GOPATH)


## Install Go
We recommend `:GoVersion` version of go as the pull request checks run against this version.

If you are having trouble following the installation guides for go, check out [Go Bootcamp](http://www.golangbootcamp.com/book/get_setup) which contains setups for every platform or reach out to the Continuous Engineering Project community in the [Continuous Engineering Project Slack channels](https://continuousengproject.slack.com).

### Install Go on macOS
If you are a macOS user and have [Homebrew](https://brew.sh/) installed on your machine, installing Go is as simple as the following command:

```sh
brew install go
```

### Install Go via GVM
More experienced users can use the [Go Version Manager](https://github.com/moovweb/gvm) (GVM). GVM allows you to switch between different Go versions *on the same machine*. If you're a beginner, you probably don't need this feature. However, GVM makes it easy to upgrade to a new released Go version with just a few commands.

GVM comes in especially handy if you follow the development of :project over a longer period of time. Future versions of :project will usually be compiled with the latest version of Go. Sooner or later, you will have to upgrade if you want to keep up.

### Install Go on Windows
Simply install the latest version by downloading the [installer](https://golang.org/dl/).


## Clearing your go module cache
If you have used an older version of go you may have old versions of go modules. So its good to run this command to clear your cache if you are having go build issues:

```sh
go clean -modcache
```


## Set up your GOPATH
Once you're finished installing Go, let's confirm everything is working correctly. Open a terminal - or command line under Windows - and type the following:

```sh
go version
```

You should see something similar to the following written to the console (on macOS). Note that the version here reflects the most recent version of Go as of the last update for this page:

```sh
go version go:GoVersion darwin/amd64
```

Next, make sure that you set up your `GOPATH` [as described in the installation guide](https://github.com/golang/go/wiki/SettingGOPATH).

You can print the `GOPATH` with `echo $GOPATH`. You should see a non-empty string containing a valid path to your Go workspace; .e.g.:

```sh
$ echo $GOPATH
/Users/<yourusername>/go
```