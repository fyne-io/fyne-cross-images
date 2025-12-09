include Makefile.inc

.PHONY: all base android darwin darwin-sdk-extractor freebsd linux windows web

# RUNNER is the CLI used to interact with docker or podman
RUNNER := $(shell 2>/dev/null 1>&2 docker version && echo "docker" || echo "podman")

base: .base
.base: base/Dockerfile
	@$(RUNNER) build -f ${CURDIR}/base/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-base .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-base ${REPOSITORY}:${PREFIX}-base
	@touch .base

android: .android
.android: .base android/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-base -f ${CURDIR}/android/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-android .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-android ${REPOSITORY}:${PREFIX}-android
	@touch .android

darwin: .darwin
.darwin: .base darwin/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-base -f ${CURDIR}/darwin/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-darwin .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-darwin ${REPOSITORY}:${PREFIX}-darwin
	@touch .darwin

darwin-sdk-extractor: .darwin-sdk-extractor
.darwin-sdk-extractor: .base darwin-sdk-extractor/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-base -f ${CURDIR}/darwin-sdk-extractor/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-darwin-sdk-extractor .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-darwin-sdk-extractor ${REPOSITORY}:${PREFIX}-darwin-sdk-extractor
	@touch .darwin-sdk-extractor

freebsd-base: .freebsd-base
.freebsd-base: .base freebsd/base/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-base -f ${CURDIR}/freebsd/base/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-base .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-base ${REPOSITORY}:${PREFIX}-freebsd-base
	@touch .freebsd-base

freebsd-amd64: .freebsd-amd64
.freebsd-amd64: .freebsd-base freebsd/amd64/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-base -f ${CURDIR}/freebsd/amd64/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-amd64 .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-amd64 ${REPOSITORY}:${PREFIX}-freebsd-amd64
	@touch .freebsd-amd64

freebsd-arm64: .freebsd-arm64
.freebsd-arm64: .freebsd-base freebsd/arm64/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-base -f ${CURDIR}/freebsd/arm64/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-arm64 .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-freebsd-arm64 ${REPOSITORY}:${PREFIX}-freebsd-arm64
	@touch .freebsd-arm64

freebsd: freebsd-amd64 freebsd-arm64

linux: .linux
.linux: .base linux/Dockerfile
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-base -f ${CURDIR}/linux/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-linux .
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-linux ${REPOSITORY}:${PREFIX}-linux
	@touch .linux

web: base
  # web image is a tag to the base image
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-base ${REPOSITORY}:${PREFIX}-${VERSION}-web
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-web ${REPOSITORY}:${PREFIX}-web

windows: base
  # windows image is a tag to the base image
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-base ${REPOSITORY}:${PREFIX}-${VERSION}-windows
	@$(RUNNER) tag ${REPOSITORY}:${PREFIX}-${VERSION}-windows ${REPOSITORY}:${PREFIX}-windows

all: base android darwin darwin-sdk-extractor freebsd linux windows web

base-pull:
	@$(RUNNER) pull ${REPOSITORY}:${PREFIX}-${VERSION}-base
	touch .base

android-push:
	@$(RUNNER) buildx build --pull --push --build-arg FYNE_CROSS_IMAGE_TAG=${REPOSITORY}:${PREFIX}-${VERSION}-base -f ${CURDIR}/android/Dockerfile -t ${REPOSITORY}:${PREFIX}-${VERSION}-android -t ${REPOSITORY}:${PREFIX}-android .
