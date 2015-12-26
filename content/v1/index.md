+++
weight = 1
date = "2015-06-29T19:14:23-05:00"
draft = false
title = "Install"

[menu.main]
parent = "Setup"
identifier = "v1"
+++

- [Installation](#installation)
- [Configuration](#configuration)
- [Environment Variables](#environment-variables)
- [Access Configuration Variables](#access-configuration-variables)

<a name="installation"></a>
## Installation

### Requirements
Gophersaurus has a few requirements:

* installed version of Go `1.5` or greater
* `$GOPATH` has been set

### Optional Settings
These are optional steps that might be worth taking the time to setup:

* `$GOPATH/bin` is part of `$PATH`

<a name="install-gophersaurus"></a>
### Install Gophersaurus

The fastest way to start a new Gophersaurus project is with the `gf` tool.
You can download the `gf` tool on your machine with the following command:

```bash
$ go get -u github.com/gophersaurus/gf
```

> NOTE: The `$` is not part of the command above, it represents the start of
> your terminal. The flag `-u` downloads and installs a fresh copy of the repo.

The `gf new` command will create a fresh Gophersaurus project.
For example, the command `gf new api` will create a directory named `api` with a new Gophersaurus installation.

More options are available that just `gf new`.
If you run `gf -h` you find more options.

<a name="configuration"></a>
## Configuration

Gophersaurus manages configuration settings by leveraging spf13's excellent `viper` package.

> You can find more about viper at https://github.com/spf13/viper.

All configuration and environment specific settings are stored in a file named `env` in the root of  the `app` directory.
The file format of `env` can be `JSON`, `YAML`, or `TOML` so your configuration file might be something like: `<projectroot>/env.yml`.

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

<a name="configuration-etc"></a>
### Configuration in etc

Gophersaurus will look for a `env.yaml` file by default in the current directory its executing in, but you can add multiple directories to search for a `env` file.

To do so simply add an `init` method that contains the following method with a path to the other directory such as `config.AddConfigPath("/etc/myproject")` to the `<projectroot>/app/app.go` file. Below is an example of what this file might look like before and after:

Before:
```Go
package app

import (
	"github.com/gophersaurus/gf.v1/bootstrap"
	"github.com/gophersaurus/gf.v1/router"
)

// Serve bootstraps the web service.
func Serve() error {
	m := router.NewMux()
	return bootstrap.Server(m, register)
}

```

After:
```Go
package app

import (
	"github.com/gophersaurus/gf.v1/bootstrap"
	"github.com/gophersaurus/gf.v1/router"
)

func init() {
  config.AddConfigPath("/etc/myproject")
}

// Serve bootstraps the web service.
func Serve() error {
	m := router.NewMux()
	return bootstrap.Server(m, register)
}
```

<a name="environment-variables"></a>
### Environment Variables

The `config` package currently handles environment variables as well.
To automatically enable them add an `init` method that contains `config.AutomaticEnv()` to the `<projectroot>/app/app.go` file. Below is an example of what this file might look like before and after:

Before:
```Go
package app

import (
	"github.com/gophersaurus/gf.v1/bootstrap"
	"github.com/gophersaurus/gf.v1/router"
)

func init() {
  config.AddConfigPath("/etc/myproject")
}

// Serve bootstraps the web service.
func Serve() error {
	m := router.NewMux()
	return bootstrap.Server(m, register)
}

```

After:
```Go
package app

import (
	"github.com/gophersaurus/gf.v1/bootstrap"
	"github.com/gophersaurus/gf.v1/router"
)

func init() {
  config.AddConfigPath("/etc/myproject")
  config.AutomaticEnv()
}

// Serve bootstraps the web service.
func Serve() error {
	m := router.NewMux()
	return bootstrap.Server(m, register)
}
```

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
