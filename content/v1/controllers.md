+++
weight = 1
date = "2015-06-29T19:14:23-05:00"
draft = false
title = "Controllers"

[menu.main]
parent = "Basics"
+++

- [Introduction](#introduction)
- [Basic Controllers](#basic-controllers)
- [Controller Middleware](#controller-middleware)
- [RESTful Resource Controllers](#restful-resource-controllers)

<a name="introduction"></a>
## Introduction

Instead of defining all of your request handling logic in a single `routes.go` file, you may wish to organize this behavior using controller structures.
Controller structs can group related HTTP request handling logic into a single object.
Controllers are stored in the `controllers` package located in the `app/controllers/` directory.

<a name="basic-controllers"></a>
## Basic Controllers

Below is an example of a very simple home controller struct located at `/app/controllers/home.go`.
All Gophersaurus controllers are simply structs.
We recommend the pattern of declaring anonymous public structs:

```go
package controllers

import "github.com/gophersaurus/gf.v1/http"

// Home is a controller.
var Home = struct {
  Welcome func(resp http.Responder, req *http.Request)
}{

  // Welcome is an action method for a GET request.
  Welcome: func(resp http.Responder, req *http.Request) {
    resp.Write(req, "Welcome fellow gopher.")
  },
}
```

We can route to the controller action like so in `/app/routes.go`:

```go
package app

import (
  c "github.com/gophersaurus/project/app/controllers"
  "github.com/gophersaurus/gf.v1/router"
)

func register(r router.Router) {
  r.GET("/welcome", c.Home.Welcome)
}
```
Now, when a request matches the specified route URI `/welcome`, the `Welcome` method attached to the `Home` controller will be executed.
Of course, the route parameters will also be passed to the method via the `http.Request` argument.

#### Controllers & Namespaces

It is helpful to note that the namespace for the `controllers` package was `c` in the example above.
The line `import c "github.com/gophersaurus/project/app/controllers"` allows us to reference the `controller` package without typing the full word "controller".
This is a useful convention when specifying multiple routes so that `controllers.Home.Welcome` becomes `c.Home.Welcome`.

Below is an example with the shorter namespace:
```go
func register(r router.Router) {
  r.GET("/", c.Home.Index)
  r.GET("/weather/:city", c.Weather.Show)
  r.GET("/stocks/:exchange/:stock", c.Stocks.Show)
  r.GET("/v2/stocks/:exchange/:stock", c.StocksV2.Show)
}
```

<a name="controller-middleware"></a>
## Controller Middleware

[Middleware](https://godoc.org/github.com/gophersaurus/gf.v1/router#Middleware) has been designed to bridge the `router` and `controllers` packages.
Middleware is defined in the `middleware` package located in the `/app/middleware` directory.
The `Middleware` type represents a function that takes a `Handler` type and returns a `Handler` type.
This taking and returns of a `Handler` type creates a chain of `Middleware`.
```go
type Middleware func(http.Handler) http.Handler
```

Typically Middleware is not attached to a particular route, instead it is assigned to a subrouter via the `Router.Subrouter` method.
This pattern provides a powerful way to secure and version different routes based on different controller's needs. Below is an example:

```go
func register(r router.Router) {

  // this subrouter has URI paths prepended with "/v1" for versioning
  v1 := r.Subrouter("/v1")

  // admin resources
  admin := v1.Subrouter("/admin").Middleware(
    m.SessionAdmin,
    m.SessionRefresh,
  )
}
```

The example above defines a `v1` subrouter.
`v1` inherits all Middleware (such as API key verification) from the original router.
`admin` is a subrouter based upon `v1`.
The `Middleware` method allows us to attach middleware only to `admin` routes.

<a name="restful-resource-controllers"></a>
## RESTful Resource Controllers

Resource controllers make it painless to build RESTful controllers around resources. For example, you may wish to create a controller that handles HTTP requests regarding "photos" stored by your application.
The photos controller file would exist at `/app/controllers/photos.go`.
The controller will contain a method for each of the available resource operations.

Verb      | Path                  | Action       | Route Method
----------|-----------------------|--------------|---------------------
GET       | `/photo`              | index        | photo.Index
POST      | `/photo`              | store        | photo.Store
GET       | `/photo/:id`          | show         | photo.Show
PUT       | `/photo/:id`          | update       | photo.Update
PATCH     | `/photo/:id`          | apply        | photo.Apply
DELETE    | `/photo/:id`          | destroy      | photo.Destroy

If a resource controller contains a method for each action method above it will satisfy the `Resourcer` interface.

```go
type Resourcer interface {
  // action methods
  Index(resp http.Responder, req *http.Request)
  Show(resp http.Responder, req *http.Request)
  Store(resp http.Responder, req *http.Request)
  Apply(resp http.Responder, req *http.Request)
  Update(resp http.Responder, req *http.Request)
  Destroy(resp http.Responder, req *http.Request)
}
```

Next, you may register a resourceful route to the controller:

```go
func register(r router.Router) {
  r.Resource("/photos", "id", c.Photos)
}
```
