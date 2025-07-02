## Description

This repository reproduces a problem I encountered when using the
`rate_limit` method on Rails version `8.0.2`. Basically, the problem
I had was that the `rate_limit` method had a separate rate limit for
each controller and there was no way of having the same rate limit on
several controllers at once.

Here's the [link](test/controllers/api_rate_limiting_test.rb) to the
test I wrote to reproduce the problem I encountered.

## Build

```sh
docker build -t reproduction-rails-rate-limit-counted-by-controller-path .
```

## Run the test

```sh
docker run -it -v "$(pwd):/app" reproduction-rails-rate-limit-counted-by-controller-path:latest bin/rails test test/controllers/api_rate_limiting_test.rb
```
