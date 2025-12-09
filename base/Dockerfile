FROM debian:trixie-slim AS base

ENV GO_VERSION=1.25.5
ENV GO_AMD64_CHECKSUM="9e9b755d63b36acf30c12a9a3fc379243714c1c6d3dd72861da637f336ebb35b"
ENV GO_ARM64_CHECKSUM="b00b694903d126c588c378e72d3545549935d3982635ba3f7a964c9fa23fe3b9"
ENV ZIG_VERSION=0.15.2
ENV ZIG_MINISIGN_KEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"
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

# Work around `fatal: detected dubious ownership in repository at ‘/app’` error reported by some users likely when UID < 1000 
RUN git config --global --add safe.directory /app && mv ~/.gitconfig /etc/gitconfig && chmod a+r /etc/gitconfig

