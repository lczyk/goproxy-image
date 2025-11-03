# This is a dockerfile for building goproxy
# Build and run with:
#   docker build -t goproxy:0.23.0 -f Dockerfile .
#   docker run -it goproxy:0.23.0

FROM golang:1.25 AS builder

WORKDIR /goproxy

ARG VERSION=v0.23.0
ARG URL=http://github.com/goproxy/goproxy.git
RUN git clone --branch ${VERSION} ${URL} .

# download upx for binary compression
RUN apt-get update && \
    apt-get install -y upx-ucl && \
    rm -rf /var/lib/apt/lists/*

# Build statically linked binary with CGO disabled
RUN CGO_ENABLED=0 \
    GOOS=linux \
    GOTOOLCHAIN=local \
    go build \
        -a \
        -ldflags '-s -w -extldflags "-static"' \
        -o goproxy cmd/goproxy/main.go

RUN upx --best --verbose goproxy
RUN mv goproxy /usr/local/bin/goproxy

FROM scratch AS release

COPY --from=builder /usr/local/bin/goproxy /usr/local/bin/goproxy

ENTRYPOINT ["/usr/local/bin/goproxy"]


