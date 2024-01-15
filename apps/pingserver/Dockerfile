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
WORKDIR /build

ADD ./apps/pingserver/go.mod .
RUN go mod download

COPY . .

ENV CGO_ENABLED 0
ENV GOOS linux

RUN go build -ldflags="-s -w" -o /app/main ./apps/pingserver/main.go

FROM alpine

RUN apk update --no-cache && apk add --no-cache ca-certificates # && apk add --no-cache tzdata

COPY --from=builder /usr/share/zoneinfo/America/New_York /usr/share/zoneinfo/America/New_York

ENV TZ America/New_York

WORKDIR /app

COPY --from=builder /app/main /app/main

CMD ["./main"]