.PHONY: base darwin darwin-sdk-extractor linux windows

# VERSION is the Fyne Cross Images version
VERSION := "1.0.0"
# REPOSITORY is the docker repository
REPOSITORY := docker.io/fyneio/fyne-cross-images
# RUNNER is the CLI used to interact with docker or podman
RUNNER := $(shell 2>/dev/null 1>&2 docker version && echo "docker" || echo "podman")

base:
	@$(RUNNER) build -f ${CURDIR}/base/Dockerfile -t ${REPOSITORY}:${VERSION}-base .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:base

darwin: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/darwin/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin ${REPOSITORY}:darwin

darwin-sdk-extractor: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/darwin-sdk-extractor/Dockerfile -t ${REPOSITORY}:${VERSION}-darwin-sdk-extractor .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-darwin-sdk-extractor ${REPOSITORY}:darwin-sdk-extractor

linux: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/linux/Dockerfile -t ${REPOSITORY}:${VERSION}-linux .
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-linux ${REPOSITORY}:linux

windows: base
    # windows image is a tag to the base image
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-base ${REPOSITORY}:${VERSION}-windows
	@$(RUNNER) tag ${REPOSITORY}:${VERSION}-windows ${REPOSITORY}:windows

all: base darwin darwin-sdk-extractor linux windows
