# goproxy-image

Bare goproxy images for easy inclusion in other dockerfiles.
All images are published to ghcr

## Usage

There is a trick for easily adding golang to a dockerfile:

```dockerfile
COPY --from=golang:1.23.11 /usr/local/go/ /usr/local/go/
```

With this image you can now do:

```dockerfile
COPY --from=ghcr.io/lczyk/goproxy-image/v0.23.0:latest /usr/bin/goproxy /usr/bin/goproxy
```

