ARG FYNE_CROSS_IMAGES_VERSION

# fyne-cross image for linux
FROM fyneio/fyne-cross-images:${FYNE_CROSS_IMAGES_VERSION}-base

ENV ANDROID_HOME /usr/local/android_sdk
ENV ANDROID_NDK_HOME ${ANDROID_HOME}/ndk-bundle
ENV ANDROID_NDK_TOOLCHAIN ${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64
ENV ANDROID_NDK_SYSLIB ${ANDROID_NDK_TOOLCHAIN}/sysroot/usr/lib/
ENV ANDROID_NDK_SYSINC ${ANDROID_NDK_TOOLCHAIN}/sysroot/usr/include/
ENV ANDROID_TMP_TOOLCHAIN /tmp/android-ndk-r25c/toolchains/llvm/prebuilt/linux-x86_64/
ENV ANDROID_TMP_SYSLIB ${ANDROID_TMP_TOOLCHAIN}/sysroot/usr/lib/
ENV ANDROID_TMP_SYSINC ${ANDROID_TMP_TOOLCHAIN}/sysroot/usr/include/
ENV COMMANDLINETOOLS_VERSION 7583922
ENV COMMANDLINETOOLS_SHA256SUM 124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf
ENV ANDROID_SDK_BUILD_TOOLS_VERSION 30.0.3
ENV ANDROID_SDK_BUILD_TOOLS_BIN ${ANDROID_HOME}/build-tools/${ANDROID_SDK_BUILD_TOOLS_VERSION}
ENV ANDROID_SDK_PLATFORM 30
ENV ANDROID_NDK_BIN ${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/x86_64/bin

ENV PATH=${PATH}:${JAVA_HOME}/bin:${ANDROID_NDK_BIN}:${ANDROID_SDK_BUILD_TOOLS_BIN}

# Install Java
RUN apt-get update && \
    apt-get upgrade -qy && \
    apt-get install -qy openjdk-11-jdk p7zip-full && \
    apt-get -qy autoremove && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*;

RUN curl -sSL -o build-tools_r33.0.1-linux.zip  https://dl.google.com/android/repository/build-tools_r33.0.1-linux.zip && \
    unzip -d  /tmp build-tools_r33.0.1-linux.zip && \
    curl -sSL -o platform-tools_r33.0.3-linux.zip https://dl.google.com/android/repository/platform-tools_r33.0.3-linux.zip && \
    unzip -d /tmp platform-tools_r33.0.3-linux.zip && \
    curl -sSl -o android-ndk-r25c-linux.zip https://dl.google.com/android/repository/android-ndk-r25c-linux.zip && \
    unzip -d /tmp android-ndk-r25c-linux.zip && \
    mkdir -p ${ANDROID_NDK_HOME} && \
    mkdir -p ${ANDROID_HOME}/build-tools/33.0.1/lib && \
    cp /tmp/android-13/aapt ${ANDROID_HOME}/build-tools/33.0.1 && \
    cp /tmp/android-13/apksigner ${ANDROID_HOME}/build-tools/33.0.1 && \
    cp /tmp/android-13/zipalign ${ANDROID_HOME}/build-tools/33.0.1 && \
    cp /tmp/android-13/d8 ${ANDROID_HOME}/build-tools/33.0.1 && \
    cp /tmp/android-13/lib/apksigner.jar ${ANDROID_HOME}/build-tools/33.0.1/lib && \
    cp /tmp/android-13/lib/d8.jar ${ANDROID_HOME}/build-tools/33.0.1/lib && \
    mkdir -p ${ANDROID_HOME}/platform-tools && \
    cp /tmp/platform-tools/adb ${ANDROID_HOME}/platform-tools && \
    mkdir -p ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/aarch64-linux-android31-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/aarch64-linux-android31-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/aarch64-linux-android21-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/aarch64-linux-android21-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/armv7a-linux-androideabi33-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/armv7a-linux-androideabi33-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/armv7a-linux-androideabi21-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/armv7a-linux-androideabi21-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/i686-linux-android33-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/i686-linux-android33-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/i686-linux-android21-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/i686-linux-android21-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/x86_64-linux-android33-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/x86_64-linux-android33-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/x86_64-linux-android21-clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp -a ${ANDROID_TMP_TOOLCHAIN}/bin/x86_64-linux-android21-clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp ${ANDROID_TMP_TOOLCHAIN}/bin/clang ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp ${ANDROID_TMP_TOOLCHAIN}/bin/clang++ ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp ${ANDROID_TMP_TOOLCHAIN}/bin/ld ${ANDROID_NDK_TOOLCHAIN}/bin && \
    cp ${ANDROID_TMP_TOOLCHAIN}/bin/llvm-nm ${ANDROID_NDK_TOOLCHAIN}/bin && \
    mkdir -p ${ANDROID_NDK_TOOLCHAIN}/lib64 && \
    cp ${ANDROID_TMP_TOOLCHAIN}/lib64/libxml2.* ${ANDROID_NDK_TOOLCHAIN}/lib64 && \
    cp ${ANDROID_TMP_TOOLCHAIN}/lib64/libc++.* ${ANDROID_NDK_TOOLCHAIN}/lib64 && \
    cp -r ${ANDROID_TMP_TOOLCHAIN}/lib64/clang ${ANDROID_NDK_TOOLCHAIN}/lib64 && \
    for arch in arm-linux-androideabi i686-linux-android aarch64-linux-android x86_64-linux-android; do \
        for v in 21 33; do \
            mkdir -p ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/crtbegin_so.o ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/crtend_so.o ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libc.so ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libGLESv2.so ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libm.so ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/liblog.so ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libEGL.so ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libdl.so ${ANDROID_NDK_SYSLIB}/$arch/$v && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libc.so ${ANDROID_NDK_SYSLIB}/$arch/$v/libgcc.so && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libc.so ${ANDROID_NDK_SYSLIB}/$arch/$v/libunwind.so && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libc++.so ${ANDROID_NDK_SYSLIB}/$arch/$v/libc++.so && \
            cp ${ANDROID_TMP_SYSLIB}/$arch/$v/libandroid.so ${ANDROID_NDK_SYSLIB}/$arch/$v; \
        done; \
        cp ${ANDROID_TMP_SYSLIB}/$arch/33/libaaudio.so ${ANDROID_NDK_SYSLIB}/$arch/33; \
    done && \
    mkdir -p ${ANDROID_NDK_SYSINC} && \
    cp -r ${ANDROID_TMP_SYSINC}/* ${ANDROID_NDK_SYSINC} && \
    rm -rf /tmp/*
