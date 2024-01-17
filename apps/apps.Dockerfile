FROM golang:alpine AS builder
#FROM base:go_builder as builder

ARG PATH_TO_MAIN=default_value

RUN apk update --no-cache && apk add --no-cache tzdata

ADD ./apps/$PATH_TO_MAIN/go.mod .
ADD ./apps/$PATH_TO_MAIN/go.sum .

RUN go mod download

WORKDIR /build
COPY . .

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOCACHE /home/user/.cache/go-build/$PATH_TO_MAIN

RUN --mount=type=cache,target=/home/user/.cache/go-build/$PATH_TO_MAIN go build -ldflags="-s -w" -o /app/main ./apps/$PATH_TO_MAIN/main.go

FROM alpine

RUN apk update --no-cache && apk add --no-cache ca-certificates

COPY --from=builder /usr/share/zoneinfo/Europe/Moscow /usr/share/zoneinfo/Europe/Moscow

ENV TZ Europe/Moscow

WORKDIR /app

COPY --from=builder /app/main /app/main

CMD ["./main"]