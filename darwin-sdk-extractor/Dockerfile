ARG FYNE_CROSS_IMAGES_VERSION

# fyne-cross image for linux
FROM fyneio/fyne-cross-images:${FYNE_CROSS_IMAGES_VERSION}-base as build

RUN set -eux; \
    apt-get update; \
    apt-get install -y -q --no-install-recommends \
        # required to complile xar and pbzx
        libxml2-dev  libssl-dev zlib1g-dev liblzma-dev libbz2-dev \
    ; \
    # remove static libs to force zig to use dynamic lib
    rm /usr/lib/*-linux-gnu/lib*.a; \
    apt-get -qy autoremove; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*;


COPY ./darwin-sdk-extractor/resources/build.zig /tmp
RUN set -eux; \ 
    mkdir /build; \
    cd /build; \
    git clone --depth 1 https://github.com/tpoechtrager/pbzx.git; \ 
    git clone --depth 1 https://github.com/tpoechtrager/xar.git; \
    cd xar/xar; CC="zig cc" ./configure; \
    cd /build; \
    mv /tmp/build.zig . ; \
    zig build 


# fyne-cross image for linux
FROM fyneio/fyne-cross-images:${FYNE_CROSS_IMAGES_VERSION}-base

COPY --from=build /build/zig-out/bin /usr/local/bin

RUN set -eux; \
    apt-get update; \
    apt-get install -y -q --no-install-recommends \
        p7zip-full cpio \
        # required by xar and pbzx
        libxml2 zlib1g lzma bzip2 \
    ; \
    apt-get -qy autoremove; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*;

COPY ./darwin-sdk-extractor/resources/darwin-sdk-extractor.sh /usr/local/bin

VOLUME [ "/mnt" ]
