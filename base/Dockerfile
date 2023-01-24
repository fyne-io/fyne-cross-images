FROM debian:bullseye-slim AS base

ENV GO_VERSION=1.19.4
# dev version of Zig to support windows-386 target
# see: https://github.com/ziglang/zig/pull/13569
ENV ZIG_VERSION=0.11.0-dev.632+d69e97ae1
ENV FYNE_VERSION=v2.3.0
ENV FIXUID_VERSION=0.5.1

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
            sha256='c9c08f783325c4cf840a94333159cc937f05f75d36a8b307951d5bd959cf2ab8'; \
            ;; \
        'arm64') \
            url="https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz";\
            sha256='9df122d6baf6f2275270306b92af3b09d7973fb1259257e284dba33c0db14f1b'; \
            ;; \
        *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
    esac; \
    curl -sSL ${url} -o go.tgz; \
    echo ${sha256} go.tgz | sha256sum -c -; \
    tar -C /usr/local -zxf go.tgz; \
    rm go.tgz; \
    go version;

ENV GOPATH /go
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
            sha256='11508dca9a4654719f337bb43d6b226cc3f17f5888cb3f277436c7944f9bcd0b'; \
            ;; \
        'arm64') \
            # dev release
            url="https://ziglang.org/builds/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            # stable release
            # url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            sha256='eea60804bb6ec17a21aed9d2e507c37e922ef285ce0142e3ef1002fcb89133a2'; \
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

# Install the fyne CLI tool
RUN set -eux; \ 
    go install -ldflags="-w -s" -v "fyne.io/fyne/v2/cmd/fyne@${FYNE_VERSION}"; \
    mv /go/bin/fyne /usr/local/bin/fyne; \
    fyne version; \
    go clean -cache -modcache;

# Install fixuid see #41
RUN arch="$(dpkg --print-architecture)"; \
    addgroup --gid 1000 docker; \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker; \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v${FIXUID_VERSION}/fixuid-${FIXUID_VERSION}-linux-${arch}.tar.gz | tar -C /usr/local/bin -xzf -; \
    chown root:root /usr/local/bin/fixuid; \
    chmod 4755 /usr/local/bin/fixuid; \
    mkdir -p /etc/fixuid; \
    printf "user: docker\ngroup: docker\n" > /etc/fixuid/config.yml
