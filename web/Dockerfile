ARG FYNE_CROSS_IMAGES_VERSION
ARG GOPHERJS_GO_VERSION=1.17.9
ARG FYNE_CROSS_REPOSITORY

# fyne-cross image for linux
FROM ${FYNE_CROSS_REPOSITORY}:${FYNE_CROSS_IMAGES_VERSION}-base
ARG GOPHERJS_GO_VERSION

# Install the GopherJS CLI tool
RUN go install -ldflags="-w -s" -v "github.com/gopherjs/gopherjs@v1.17.2+go1.17.9"; \
    mv /go/bin/gopherjs /usr/local/bin/gopherjs; \
    # Install the Go version compatible with the GopherJS
    go install golang.org/dl/go${GOPHERJS_GO_VERSION}@latest; \ 
    go${GOPHERJS_GO_VERSION} download; \
    rm /root/sdk/go${GOPHERJS_GO_VERSION}/*.tar.gz; \
    mv /root/sdk/go${GOPHERJS_GO_VERSION} /usr/local; \
    rm -rf /go/pkg

ENV GOPHERJS_GOROOT="/usr/local/go${GOPHERJS_GO_VERSION}"