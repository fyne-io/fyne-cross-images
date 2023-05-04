ARG FYNE_CROSS_IMAGES_VERSION
ARG FYNE_CROSS_REPOSITORY

# fyne-cross image for linux
FROM ${FYNE_CROSS_REPOSITORY}:${FYNE_CROSS_IMAGES_VERSION}-base

RUN set -eux; \
    dpkg --add-architecture arm64; \
    dpkg --add-architecture amd64; \
    dpkg --add-architecture armhf; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y -q --no-install-recommends \
        libgl-dev:amd64 \
        libx11-dev:amd64 \
        libxrandr-dev:amd64 \
        libxxf86vm-dev:amd64 \
        libxi-dev:amd64 \
        libxcursor-dev:amd64 \
        libxinerama-dev:amd64 \
         # deps to support wayland
        libxkbcommon-dev:amd64 \
    ; \
    apt-get install -y -q --no-install-recommends \
        libgl-dev:arm64 \
        libx11-dev:arm64 \
        libxrandr-dev:arm64 \
        libxxf86vm-dev:arm64 \
        libxi-dev:arm64 \
        libxcursor-dev:arm64 \
        libxinerama-dev:arm64 \
         # deps to support wayland
        libxkbcommon-dev:arm64 \
    ; \
    apt-get install -y -q --no-install-recommends \
        libgl-dev:armhf \
        libx11-dev:armhf \
        libxrandr-dev:armhf \
        libxxf86vm-dev:armhf \
        libxi-dev:armhf \
        libxcursor-dev:armhf \
        libxinerama-dev:armhf \
         # deps to support wayland
        libxkbcommon-dev:armhf \
    ; \
    apt-get install -y -q --no-install-recommends \
        libgl-dev:i386 \
        libx11-dev:i386 \
        libxrandr-dev:i386 \
        libxxf86vm-dev:i386 \
        libxi-dev:i386 \
        libxcursor-dev:i386 \
        libxinerama-dev:i386 \
         # deps to support wayland
        libxkbcommon-dev:i386 \
    ; \
    # remove static libX11 to allow zig build against shared X11 lib
    rm -rf /usr/lib/*/libX11.a; \
    apt-get -qy autoremove; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*;
