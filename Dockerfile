FROM golang:alpine as builder
WORKDIR /go/src/oauth2_proxy
RUN apk add --no-cache git curl
RUN curl -L https://github.com/bitly/oauth2_proxy/archive/ae49c7d23c8bc677ff44b4a6273c07d94049ef65.zip -o /go/src/oauth2_proxy.zip && unzip /go/src/oauth2_proxy.zip -d /go/src/
RUN mv -v /go/src/oauth2_proxy-ae49c7d23c8bc677ff44b4a6273c07d94049ef65/* /go/src/oauth2_proxy
RUN go get -v
RUN go build .

FROM alpine
COPY --from=builder /go/bin/oauth2_proxy /oauth2_proxy
RUN apk add --no-cache ca-certificates
EXPOSE 4180

ENTRYPOINT ["/oauth2_proxy"]
