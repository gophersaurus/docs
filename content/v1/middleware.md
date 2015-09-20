+++
weight = 1
date = "2015-06-29T19:14:23-05:00"
draft = false
title = "Middleware"

[menu.main]
parent = "Basics"
+++

- [Introduction](#introduction)
- [Defining Middleware](#defining-middleware)

<a name="introduction"></a>
## Introduction

HTTP middleware provide a convenient mechanism for filtering HTTP requests entering your application.
For example, gophersaurus includes a middleware that verifies that the client has a valid API key and whitelisted IP address.
If the client does not provided a proper API key or is not a whitelisted IP, the middleware will not allow the request to proceed further into the application.

Of course, additional middleware can be written to perform a variety of tasks besides authentication.
A CORS middleware might be responsible for adding the proper headers to all responses leaving your application.
A logging middleware might log all incoming requests to your application.

All middleware is located in the `/app/middleware` directory.

<a name="defining-middleware"></a>
## Defining Middleware

[Middleware](https://godoc.org/github.com/gophersaurus/gf.v1/router#Middleware) has been designed to bridge the `router` and `controllers` packages.
Middleware is defined in the `middleware` package located in the `/app/middleware` directory.
The `Middleware` type represents a function that takes a `Handler` type and returns a `Handler` type.
This taking and returns of a `Handler` type creates a chain of `Middleware`.
```go
type Middleware func(http.Handler) http.Handler
```

To create a new middleware, add a `.go` file to the `/app/middleware` directory.

Below is an example middleware.  In this middleware, we will only allow parameter values for age that are equal or greater than than 200. Otherwise, we will return an error message.

```go
// Age describes a middleware that checks the age parameter
// for a value equal or greater than 200.
type Age struct {
  next http.Handler
}

// Do takes a handler and executes age middleware.
func (a Age) Do(h http.Handler) http.Handler {
	a.next = h
	return a
}

// ServeHTTP fulfills the http package interface for middleware.
func (a Age) ServeHTTP(resp http.Responder, req *http.Request) {

  // get the value of the age parameter
  age := req.Param("age")

  // convert age from a string type to an integer type
  if i, err := strconv.Atoi(age); err == nil {
    resp.WriteErrs(req, err.Error(), fmt.Sprintf("unable to convert '%s' to a string", age)
    return
  }

  // check the value of age is greater or equal to 200
  if i < 200 {
    resp.WriteErrs(req, "the value of age must be greater than 200")
    return
  }

  // execute the next middleware
  a.next.ServeHTTP(resp, req)
}
```

As you can see, if the given `age` is less than `200`, the middleware will return an HTTP error to the client; otherwise, the request will be passed further into the application.

It's best to envision middleware as a series of "layers" HTTP requests must pass through before they hit your application. Each layer can examine the request and even reject it entirely.
