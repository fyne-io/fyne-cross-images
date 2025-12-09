# VERSION is the Fyne Cross Images version
VERSION := $(shell git tag --points-at HEAD | awk -v def="dev" '{print} END { if(NR==0) {print def} }')
# REPOSITORY is the docker repository
REPOSITORY := docker.io/fyneio/fyne-cross-images
# PREFIX is the image tag prefix (defaults to "tools")
PREFIX ?= tools

version:
	@echo $(VERSION)

image-tag:
	@echo $(PREFIX)-$(VERSION)
