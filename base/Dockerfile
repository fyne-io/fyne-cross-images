FROM debian:bullseye-slim AS base

ENV GO_VERSION=1.22.5
# dev version of Zig to support windows-386 target
# see: https://github.com/ziglang/zig/pull/13569
ENV ZIG_VERSION=0.13.0
ENV FYNE_VERSION=v2.4.4
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
            sha256='904b924d435eaea086515bc63235b192ea441bd8c9b198c507e85009e6e4c7f0'; \
            ;; \
        'arm64') \
            url="https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz";\
            sha256='8d21325bfcf431be3660527c1a39d3d9ad71535fabdf5041c826e44e31642b5a'; \
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
            # url="https://ziglang.org/builds/zig-linux-x86_64-${ZIG_VERSION}.tar.xz";\
            # stable release
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz";\
            sha256='d45312e61ebcc48032b77bc4cf7fd6915c11fa16e4aad116b66c9468211230ea'; \
            ;; \
        'arm64') \
            # dev release
            #url="https://ziglang.org/builds/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            # stable release
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            sha256='041ac42323837eb5624068acd8b00cd5777dac4cf91179e8dad7a7e90dd0c556'; \
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
