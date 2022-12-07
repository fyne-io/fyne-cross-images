# VERSION is the Fyne Cross Images version
VERSION := "1.0.0"
# REPOSITORY is the docker repository
REPOSITORY := docker.io/fyneio/fyne-cross-images
# RUNNER is the CLI used to interact with docker or podman
RUNNER := $(shell 2>/dev/null 1>&2 docker version && echo "docker" || echo "podman")

base:
	@$(RUNNER) build -f ${CURDIR}/base.Dockerfile -t ${REPOSITORY}:${VERSION}-base .

linux: base
	@$(RUNNER) build --build-arg FYNE_CROSS_IMAGES_VERSION=${VERSION} -f ${CURDIR}/linux.Dockerfile -t ${REPOSITORY}:${VERSION}-linux .
