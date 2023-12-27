FROM debian:bullseye-slim AS base

ENV GO_VERSION=1.21.5
# dev version of Zig to support windows-386 target 
# see: https://github.com/ziglang/zig/pull/13569
ENV ZIG_VERSION=0.11.0-dev.2935+ec6ffaa1e
ENV FYNE_VERSION=v2.4.3
ENV FIXUID_VERSION=0.6.0

# Install common dependencies

RUN set -eux; \
    apt-get update; \
    apt-get install -y -q --no-install-recommends \
        ca-certificates \
        curl \
        git \
        pkg-config \
        unzip \
        xz-utils \
        zip \
    ; \
    apt-get -qy autoremove; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*;

# Add Go and Zig to PATH
ENV PATH /usr/local/go/bin:/usr/local/zig:$PATH

# Install Go
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    url=; \
    sha256=; \
    case "$arch" in \
        'amd64') \
            url="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz";\
            sha256='e2bc0b3e4b64111ec117295c088bde5f00eeed1567999ff77bc859d7df70078e'; \
            ;; \
        'arm64') \
            url="https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz";\
            sha256='841cced7ecda9b2014f139f5bab5ae31785f35399f236b8b3e75dff2a2978d96'; \
            ;; \
        *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
    esac; \
    curl -sSL ${url} -o go.tgz; \
    echo ${sha256} go.tgz | sha256sum -c -; \
    tar -C /usr/local -zxf go.tgz; \
    rm go.tgz; \
    go version;

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH


# Install Zig
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    url=; \
    sha256=; \
    case "$arch" in \
        'amd64') \
            # dev release
            url="https://ziglang.org/builds/zig-linux-x86_64-${ZIG_VERSION}.tar.xz";\
            # stable release
            # url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz";\
            sha256='6b604a09b5e3cfaf1643268488746e703c00418f5c2f3021cf50a5b6efbc02f8'; \
            ;; \
        'arm64') \
            # dev release
            url="https://ziglang.org/builds/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            # stable release
            # url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            sha256='c3c9d2a986bf99ab07c47e1c268b494a33accf416547ad7b99915715af3f5c74'; \
            ;; \
        *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
    esac; \
    curl -sSL ${url} -o zig.tar.xz; \
    echo ${sha256} zig.tar.xz | sha256sum -c -; \
    tar -C /usr/local -Jxvf zig.tar.xz; \
    mv /usr/local/zig-* /usr/local/zig; \
    rm zig.tar.xz; \
    zig version;

# Zig: add arm-features.h from glibc source to allow build on linux arm. See https://github.com/ziglang/zig/pull/12346
# TODO: remove once 0.10.1 or greater is released
RUN curl -SsL  https://raw.githubusercontent.com/ziglang/zig/d9a754e5e39f6e124b9f5be093d89ba30f16f085/lib/libc/glibc/sysdeps/arm/arm-features.h > /usr/local/zig/lib/libc/glibc/sysdeps/arm/arm-features.h

##################################################################
### Tools section
### NOTE: Ensure all tools are installed under /usr/local/bin
##################################################################

# Install the fyne-cross-s3 download and upload tool
RUN set -eux; \
    go install -ldflags="-w -s" -v "github.com/fyne-io/fyne-cross/internal/cmd/fyne-cross-s3@develop"; \
    mv /go/bin/fyne-cross-s3 /usr/local/bin/fyne-cross-s3;

# Install the fyne CLI tool
RUN set -eux; \ 
    go install -ldflags="-w -s" -v "fyne.io/fyne/v2/cmd/fyne@${FYNE_VERSION}"; \
    mv /go/bin/fyne /usr/local/bin/fyne; \
    fyne version; \
    go clean -cache -modcache; \
    mkdir -p "$GOPATH/pkg/mod" && chmod -R 777 "$GOPATH"

# Work around `fatal: detected dubious ownership in repository at ‘/app’` error reported by some users likely when UID < 1000 
RUN git config --global --add safe.directory /app && mv ~/.gitconfig /etc/gitconfig && chmod a+r /etc/gitconfig

# Install fixuid see #41
RUN arch="$(dpkg --print-architecture)"; \
    addgroup --gid 1000 docker; \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker; \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v${FIXUID_VERSION}/fixuid-${FIXUID_VERSION}-linux-${arch}.tar.gz | tar -C /usr/local/bin -xzf -; \
    chown root:root /usr/local/bin/fixuid; \
    chmod 4755 /usr/local/bin/fixuid; \
    mkdir -p /etc/fixuid; \
    printf "user: docker\ngroup: docker\n" > /etc/fixuid/config.yml
