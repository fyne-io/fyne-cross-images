.PHONY: all base android darwin darwin-sdk-extractor freebsd linux windows web

# VERSION is the Fyne Cross Images version
VERSION := "1.0.0"
# REPOSITORY is the docker repository
REPOSITORY := docker.io/fyneio/fyne-cross-images
# RUNNER is the CLI used to interact with docker or podman
RUNNER := $(shell 2>/dev/null 1>&2 docker version && echo "docker" || echo "podman")

base:
	@$(RUNNER) build -f ${CURDIR}/base/Dockerfile -t ${REPOSITORY}:${VERSION}-base .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:base

android: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/android/Dockerfile -t ${REPOSITORY}:${VERSION}-android .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-android ${REPOSITORY}:android

darwin: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/darwin/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin ${REPOSITORY}:darwin

darwin-sdk-extractor: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/darwin-sdk-extractor/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin-sdk-extractor .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin-sdk-extractor ${REPOSITORY}:darwin-sdk-extractor

freebsd-base: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/freebsd/base/Dockerfile -t ${REPOSITORY}:${VERSION}-freebsd-base .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-freebsd-base ${REPOSITORY}:freebsd-base

freebsd-amd64: freebsd-base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/freebsd/amd64/Dockerfile -t ${REPOSITORY}:${VERSION}-freebsd-amd64 .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-freebsd-amd64 ${REPOSITORY}:freebsd-amd64

freebsd-arm64: freebsd-base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/freebsd/arm64/Dockerfile -t ${REPOSITORY}:${VERSION}-freebsd-arm64 .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-freebsd-arm64 ${REPOSITORY}:freebsd-arm64

freebsd: freebsd-amd64 freebsd-arm64

linux: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/linux/Dockerfile -t ${REPOSITORY}:${VERSION}-linux .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-linux ${REPOSITORY}:linux

web: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/web/Dockerfile -t ${REPOSITORY}:${VERSION}-web .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-web ${REPOSITORY}:web

windows: base
    # windows image is a tag to the base image
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:${VERSION}-windows
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-windows ${REPOSITORY}:windows

all: base android darwin darwin-sdk-extractor freebsd linux windows
