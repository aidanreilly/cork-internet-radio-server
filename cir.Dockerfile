FROM --platform=$BUILDPLATFORM golang:1.23-bookworm

WORKDIR /app

COPY . .
RUN go mod download

ARG TARGETPLATFORM
RUN echo "Building for platform: $TARGETPLATFORM"

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      GOARCH=arm64 GOOS=linux go build -o /cir ; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      GOARCH=amd64 GOOS=linux go build -o /cir ; \
    fi

EXPOSE 9222

CMD ["/cir"]
