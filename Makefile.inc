# VERSION is the Fyne Cross Images version
VERSION := $(shell git tag --points-at HEAD | awk -v def="dev" '{print} END { if(NR==0) {print def} }')
# REPOSITORY is the docker repository
REPOSITORY := docker.io/fyneio/fyne-cross-images

version:
	@echo $(VERSION)
