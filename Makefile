.PHONY: all base android darwin darwin-sdk-extractor freebsd linux windows web

# VERSION is the Fyne Cross Images version
VERSION := "1.0.0"
# REPOSITORY is the docker repository
REPOSITORY := docker.io/fyneio/fyne-cross-images
# RUNNER is the CLI used to interact with docker or podman
RUNNER := $(shell 2>/dev/null 1>&2 docker version && echo "docker" || echo "podman")

base: .base
.base:
	@$(RUNNER) build -f ${CURDIR}/base/Dockerfile -t ${REPOSITORY}:${VERSION}-base .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:base
	@touch .base

android: .android
.android: .base android/Dockerfile
	@$(RUNNER) build --arch=amd64 --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/android/Dockerfile -t ${REPOSITORY}:${VERSION}-android .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-android ${REPOSITORY}:android
	@touch .android

darwin: .darwin
.darwin: .base darwin/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/darwin/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin ${REPOSITORY}:darwin
	@touch .darwin

darwin-sdk-extractor: .darwin-sdk-extractor
.darwin-sdk-extractor: .base darwin-sdk-extractor/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/darwin-sdk-extractor/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin-sdk-extractor .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin-sdk-extractor ${REPOSITORY}:darwin-sdk-extractor
	@touch .darwin-sdk-extractor

freebsd-base: .freebsd-base
.freebsd-base: .base freebsd/base/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/freebsd/base/Dockerfile -t ${REPOSITORY}:${VERSION}-freebsd-base .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-freebsd-base ${REPOSITORY}:freebsd-base
	@touch .freebsd-base

freebsd-amd64: .freebsd-amd64
.freebsd-amd64: .freebsd-base freebsd/amd64/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/freebsd/amd64/Dockerfile -t ${REPOSITORY}:${VERSION}-freebsd-amd64 .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-freebsd-amd64 ${REPOSITORY}:freebsd-amd64
	@touch .freebsd-amd64

freebsd-arm64: .freebsd-arm64
.freebsd-arm64: .freebsd-base freebsd/arm64/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/freebsd/arm64/Dockerfile -t ${REPOSITORY}:${VERSION}-freebsd-arm64 .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-freebsd-arm64 ${REPOSITORY}:freebsd-arm64
	@touch .freebsd-arm64

freebsd: freebsd-amd64 freebsd-arm64

linux: .linux
.linux: .base linux/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/linux/Dockerfile -t ${REPOSITORY}:${VERSION}-linux .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-linux ${REPOSITORY}:linux
	@touch .linux

web: .web
.web: .base web/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} --build-arg FYNE_CROSS_REPOSITORY=${REPOSITORY} -f ${CURDIR}/web/Dockerfile -t ${REPOSITORY}:${VERSION}-web .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-web ${REPOSITORY}:web
	@touch .web

windows: base
    # windows image is a tag to the base image
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:${VERSION}-windows
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-windows ${REPOSITORY}:windows

all: base android darwin darwin-sdk-extractor freebsd linux windows web
