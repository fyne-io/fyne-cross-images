ARG FYNE_CROSS_IMAGES_VERSION

# fyne-cross image for darwin
FROM fyneio/fyne-cross-images:${FYNE_CROSS_IMAGES_VERSION}-base

# 0.9.1 version of Zig to support darwin targets
# see: ...
ENV ZIG_VERSION=0.9.1

# Install Zig
RUN set -eux; \
    rm -rf /usr/local/zig; \
    arch="$(dpkg --print-architecture)"; \
    url=; \
    sha256=; \
    case "$arch" in \
        'amd64') \
            # stable release
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz";\
            sha256='be8da632c1d3273f766b69244d80669fe4f5e27798654681d77c992f17c237d7'; \
            ;; \
        'arm64') \
            # stable release
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-aarch64-${ZIG_VERSION}.tar.xz";\
            sha256='5d99a39cded1870a3fa95d4de4ce68ac2610cca440336cfd252ffdddc2b90e66'; \
            ;; \
        *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
    esac; \
    curl -sSL ${url} -o zig.tar.xz; \
    echo ${sha256} zig.tar.xz | sha256sum -c -; \
    tar -C /usr/local -Jxvf zig.tar.xz; \
    mv /usr/local/zig-* /usr/local/zig; \
    zig version;
