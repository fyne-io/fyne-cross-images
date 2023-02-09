ARG FYNE_CROSS_IMAGES_VERSION

# fyne-cross image for linux
FROM fyneio/fyne-cross-images:${FYNE_CROSS_IMAGES_VERSION}-base

ENV ANDROID_HOME /usr/local/android_sdk
ENV COMMANDLINETOOLS_VERSION 7583922
ENV COMMANDLINETOOLS_SHA256SUM 124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf
ENV ANDROID_SDK_BUILD_TOOLS_VERSION 30.0.3
ENV ANDROID_SDK_BUILD_TOOLS_BIN ${ANDROID_HOME}/build-tools/${ANDROID_SDK_BUILD_TOOLS_VERSION}
ENV ANDROID_SDK_PLATFORM 30
ENV ANDROID_NDK_BIN ${ANDROID_HOME}/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/bin

ENV PATH=${PATH}:${JAVA_HOME}/bin:${ANDROID_NDK_BIN}:${ANDROID_SDK_BUILD_TOOLS_BIN}

# Install Java
RUN apt-get install -y -q --no-install-recommends openjdk-11-jdk; \
    apt-get -qy autoremove; \
    apt-get clean; \
    rm -r /var/lib/apt/lists/*;

# Install command line tools
RUN wget -O sdk.zip "https://dl.google.com/android/repository/commandlinetools-linux-${COMMANDLINETOOLS_VERSION}_latest.zip"; \
	echo "${COMMANDLINETOOLS_SHA256SUM} *sdk.zip" | sha256sum -c -; \
	unzip -d /tmp sdk.zip; \
	mkdir -p ${ANDROID_HOME}/cmdline-tools; \
	mv /tmp/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest; \
	rm sdk.zip;

# Install tools, platforms and ndk
RUN yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager \
	"build-tools;${ANDROID_SDK_BUILD_TOOLS_VERSION}" \
	"ndk-bundle" \
	"platforms;android-${ANDROID_SDK_PLATFORM}" \
	"platform-tools"
