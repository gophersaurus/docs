# docs
Gophersaurus Framework Documentation

[![Build Status](https://drone.io/github.com/gophersaurus/docs/status.png)](https://drone.io/github.com/gophersaurus/docs/latest)

Documentation for the [Gophersaurus](https://github.com/gophersaurus/framework) framework, found at [readme.drone.io](https://gophersaurus.github.io/docs)

## Setup

This website uses the [Hugo](https://github.com/spf13/hugo) static site generator. If you are planning to contribute you'll want to download and install Hugo on your local machine.

Install on OSX with brew:

```
brew install hugo
```

Install using the Go tool:

```
go get github.com/spf13/hugo
```

Or follow these instructions for your platform: http://gohugo.io/overview/installing/

## Build

Generate the website and output to `./public`

```
hugo -t gophersaurus
```

Generate the website, serve on localhost:1313, and automatically refresh the browser when a change is detected:

```
hugo server -w -t gophersaurus
```
