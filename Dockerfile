FROM golang:alpine as builder
WORKDIR /go/src/oauth2_proxy
COPY . .
RUN apk add --no-cache git
RUN go get -v
RUN go build .

FROM alpine
COPY --from=builder /go/bin/oauth2_proxy /oauth2_proxy
RUN apk add --no-cache ca-certificates
EXPOSE 4180

ENTRYPOINT ["/oauth2_proxy"]
