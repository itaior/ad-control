# build stage
FROM golang:alpine AS build-env
RUN apk update && apk add curl git
RUN mkdir -p /go/src/github.com/jitaior/ad-control
WORKDIR /go/src/github.com/itaior/ad-control
COPY main.go .
COPY glide.yaml .
COPY glide.lock .
RUN curl https://glide.sh/get | sh
RUN glide install
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o webhook

FROM alpine:latest

COPY --from=build-env /go/src/github.com/itaior/ad-control/webhook .
ENTRYPOINT ["/webhook"]