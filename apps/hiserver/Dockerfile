#FROM golang:alpine AS builder
#
#LABEL stage=gobuilder
#
#
#RUN apk update --no-cache && apk add --no-cache tzdata
#
#WORKDIR /build
#
#
#ADD go.sum .

FROM base:go_builder as builder

RUN apk update --no-cache && apk add --no-cache tzdata
ARG PATH_TO_MAIN=default_value

WORKDIR /build

ADD $PATH_TO_MAIN/go.mod .
ADD $PATH_TO_MAIN/go.sum .
RUN go mod download

COPY . .

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOCACHE /home/user/.cache/go-build

RUN --mount=type=cache,target=/home/user/.cache/go-build go build -ldflags="-s -w" -o /app/main $PATH_TO_MAIN/main.go

FROM alpine

RUN apk update --no-cache && apk add --no-cache ca-certificates

COPY --from=builder /usr/share/zoneinfo/Europe/Moscow /usr/share/zoneinfo/Europe/Moscow

ENV TZ Europe/Moscow

WORKDIR /app

COPY --from=builder /app/main /app/main

CMD ["./main"]