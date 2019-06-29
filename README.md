# Supported tags and respective Dockerfile links

* ``1.0.0`` ``latest``

# Quick Reference

* unicorn_ Rack HTTP server for fast clients and Unix<br>
  https://bogomips.org/unicorn/
* unicorn _ RubyGems.org _ コミュニティのGemホスティングサービス<br>
  https://rubygems.org/gems/unicorn/versions/5.1.0

# What is unicorn

unicorn is an HTTP server for Rack applications designed to only serve fast clients on low-latency, high-bandwidth connections and take advantage of features in Unix/Unix-like kernels. Slow clients should only be served by placing a reverse proxy capable of fully buffering both the the request and response in between unicorn and slow clients.

# How to use this image

## Start a unicorn instance

```
$ docker run --name container-name -d katsuya61/unicorn
```

## Exposing external port

```
$ docker run --name container-name -d -p 3000:3000 katsuya61/unicorn
```

Then you can hit http://localhost:3000 or http://host-ip:3000 in your browser.
