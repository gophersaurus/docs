+++
weight = 1
date = "2015-06-29T19:14:23-05:00"
draft = true
title = "Install"

[menu.main]
parent = "Setup"
+++

- [Installation](#installation)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Access Configuration Variables](#access-configuration-variables)

<a name="installation"></a>
## Installation

### Requirements
Gophersaurus has a few system requirements:

* installed version of Go `go1.5.1` or greater
* `$GOPATH` has been set
* `$GOPATH/bin` is part of `$PATH` (optional)

<a name="install-gophersaurus"></a>
### Installing Gophersaurus

The fastest way to start a new Gophersaurus project is with the `gf` tool.
You can download the `gf` tool on your machine with the following command:

```bash
$ go get -u github.com/gophersaurus/gf
```

> NOTE: The `$` is not part of the command above, it represents the start of
> your terminal. The flag `-u` downloads and installs a fresh copy of the repo.

The `gf new` command will create a fresh Gophersaurus project.
For example, the command `gf new api` will create a directory named `api` with a fresh Gophersaurus installation.

More options are available that just `gf new`. If you run `gf -h` you will see the following:

```bash
$ gf -h
The Gophersaurus project tool.

Usage:
   [flags]
   [command]

Available Commands:
  new         Update Gophersaurus.
  update      Update the Gophersaurus framework.
  version     Installed version of the gf tool.

Flags:
  -v, --verbose[=false]: Print verbose output

Use " [command] --help" for more information about a command.
```

<a name="configuration"></a>
## Configuration

Gophersaurus manages configuration settings by leveraging spf13's `viper` package.

> You can find more about viper at https://github.com/spf13/viper.

All configuration settings are stored in a file named `config` under the `app` directory.
The file format of `config` can be `JSON`, `XML`, or `YAML`, so your configuration file might be something like: `/app/config.yml`.
Viper supports environment variables as well as `etcd` and `consul` out of the box.

#### Port & Application Keys

The first thing you need to do when setting configuring variables is specify a port and API keys.

Below is an example of a yaml config file that contains a port number and a single API key that accepts connections from any IP address:
```YAML
port: 5225
keys:
  gophersaurus:
    - all
```

You can specify that only localhost connections are allowed for local development or whitelist specific IPs for production:
```YAML
port: 5225
keys:
  gophersaurus:
    - all
  localGophersaurus:
    - localhost
  whitelistGophersaurus:
    - 192.168.1.1
    - 10.10.20.21
    - 8.8.8.8
    - 8.8.4.4
```

Any kind of variables can be included in this configuration file as well.
To access those variables

<a name="environment-variables"></a>
### Environment Variables

The `config` package currently handles environment variables as well.
Currently to enable them you must update the `config.AutomaticEnv()` method within the `/app/bootstrap/config.go` file.

<a name="access-configuration-variables"></a>
### Access Configuration Variables

You can easily access your configuration values using the `config` package.

> The documentation for the `config` package can be found on [godoc](http://godoc.org/github.com/gophersaurus/gf.v1/config).

After including `github.com/gophersaurus/gf.v1/config` the configuration values may be accessed via the methods provided by the `config` package.

For example, if you have a configuration file like:
```YAML
port: 5225
keys:
  gophersaurus:
    - all
  localGophersaurus:
    - localhost
  whitelistGophersaurus:
    - 192.168.1.1
    - 10.10.20.21
    - 8.8.8.8
    - 8.8.4.4
```

You can retrieve the `port` and `keys` values using the following `config` package methods:

```go
port := config.GetString("port")
keys := config.GetStringMapStringSlice("keys")
```

These methods also work for local environment variables.
