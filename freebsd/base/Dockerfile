ARG FYNE_CROSS_IMAGES_VERSION
ARG FYNE_CROSS_REPOSITORY

# fyne-cross image for linux
FROM ${FYNE_CROSS_REPOSITORY}:${FYNE_CROSS_IMAGES_VERSION}-base AS pkg

RUN set -eux; \
    apt-get update; \
    apt-get install -y -q --no-install-recommends \
        libsqlite3-dev \
        libbsd-dev \
        libarchive-tools \
        libarchive-dev \
        libssl-dev \
        liblzma-dev \
        liblua5.2-dev \
        nettle-dev \
        liblzo2-dev \
        libattr1-dev \
        libacl1-dev \
        build-essential \
        zlib1g-dev \
        libbz2-dev \
        m4 \
        libexpat1-dev \
        liblz4-dev \
        libxml2-dev \
        libzstd-dev \
        kyua \
        atf-sh \
        libatf-dev \
        bzip2 \
    ; \
    apt-get -qy autoremove; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*;

RUN mkdir -p /pkg-src \
    && mkdir -p /pkg/etc \
    && curl -L https://github.com/freebsd/pkg/archive/1.19.0.tar.gz | bsdtar -xf - -C /pkg-src \
    && cd /pkg-src/pkg-* \ 
    && ./configure --with-libarchive.pc --prefix=/pkg \
    && make -j4 || make V=1 \
    && make install \
    && rm -rf /pkg-src

FROM pkg

COPY --from=pkg /pkg /pkg

ENV PATH=/pkg/sbin:${PATH}
ENV LLVM_VERSION=17
 
RUN apt-get update -qq \
    && apt install -y -q --no-install-recommends gnupg \
    && curl -L https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-${LLVM_VERSION} main" | tee /etc/apt/sources.list.d/llvm.list > /dev/null \
    && apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
        clang-${LLVM_VERSION} \
        llvm-${LLVM_VERSION} \
        lld-${LLVM_VERSION}  \
    && apt-get -qy autoremove \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/*;

ENV PATH=/usr/lib/llvm-${LLVM_VERSION}/bin:${PATH}
