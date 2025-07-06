FROM debian:bookworm-slim AS base

ENV GO_VERSION=1.24.4
ENV GO_AMD64_CHECKSUM="77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717"
ENV GO_ARM64_CHECKSUM="d5501ee5aca0f258d5fe9bfaed401958445014495dc115f202d43d5210b45241"
ENV ZIG_VERSION=0.14.1
ENV ZIG_MINISIGN_KEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"
ENV FYNE_VERSION=v2.5.5
ENV FIXUID_VERSION=0.5.1
ENV MINISIGN_VERSION=0.12

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
            sha256=${GO_AMD64_CHECKSUM};\
            ;; \
        'arm64') \
            url="https://go.dev/dl/go${GO_VERSION}.linux-arm64.tar.gz";\
            sha256=${GO_ARM64_CHECKSUM};\
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

# don't auto-upgrade the gotoolchain
# https://github.com/docker-library/golang/issues/472
ENV GOTOOLCHAIN=local

# Install minisign
RUN set -eux; \
    curl -sSL https://github.com/jedisct1/minisign/releases/download/${MINISIGN_VERSION}/minisign-${MINISIGN_VERSION}-linux.tar.gz -o minisign.tgz; \
    mkdir -p /usr/local/minisign; ls -l;\
    tar -C /usr/local/minisign --strip-components=1 -zxvf minisign.tgz; \
    rm minisign.tgz

# Install Zig
RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    url=; \
    public_key=${ZIG_MINISIGN_KEY}; \
    case "$arch" in \
        'amd64') \
            arch="x86_64";\
            # dev release
            # url="https://ziglang.org/builds/zig-${arch}-linux-${ZIG_VERSION}.tar.xz";\
            # stable release
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-${arch}-linux-${ZIG_VERSION}.tar.xz";\
            ;; \
        'arm64') \
            arch="aarch64";\
            # dev release
            #url="https://ziglang.org/builds/zig-${arch}-linux-${ZIG_VERSION}.tar.xz";\
            # stable release
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-${arch}-linux-${ZIG_VERSION}.tar.xz";\
            ;; \
        *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
    esac; \
    curl -sSL ${url} -o zig.tar.xz; \
    curl -sSL ${url}.minisig -o zig.tar.xz.minisig; \
    /usr/local/minisign/${arch}/minisign -Vm zig.tar.xz -P ${public_key}; \
    tar -C /usr/local -Jxvf zig.tar.xz; \
    mv /usr/local/zig-* /usr/local/zig; \
    rm zig.tar*; \
    zig version;

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
