ARG FYNE_CROSS_IMAGES_VERSION
ARG FYNE_CROSS_REPOSITORY

# fyne-cross image for linux
FROM ${FYNE_CROSS_REPOSITORY}:${FYNE_CROSS_IMAGES_VERSION}-freebsd-base AS pkg

# Download FreeBSD base, extract libs/includes, pkg keys and configs
# and install fyne dependencies
# Based on: https://github.com/myfreeweb/docker-freebsd-cross/tree/fc70196f62c00a10eb61a45a4798e09214e0cdfd
ENV ABI="FreeBSD:14:amd64"
RUN mkdir /freebsd \
    && mkdir /etc/pkg/ \
	&& curl https://download.freebsd.org/ftp/releases/amd64/14.2-RELEASE/base.txz | \
		bsdtar -xf - -C /freebsd ./lib ./usr/lib ./usr/libdata ./usr/include ./usr/share/keys ./etc \
    && cp /freebsd/etc/pkg/FreeBSD.conf /etc/pkg/ \
    && ln -s /freebsd/usr/share/keys /usr/share/keys 

# Set pkg variables required to compile
ENV PKG_CONFIG_SYSROOT_DIR=/freebsd
ENV PKG_CONFIG_LIBDIR=/freebsd/usr/libdata/pkgconfig:/freebsd/usr/local/libdata/pkgconfig

RUN pkg fetch -o /tmp/download --yes -d xorg glfw; \
    #bsdtar -C /freebsd /tmp/download/All/*.pkg; \
    rm -rf /tmp/download/All/*llvm*; \
    rm -rf /tmp/download/All/*perl*; \
    rm -rf /tmp/download/All/*python*; \
    for f in  /tmp/download/All/*.pkg;\ 
        do bsdtar -xvf "$f" -C /freebsd;\
    done; \
    rm -rf /tmp/download
