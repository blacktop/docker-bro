FROM golang:alpine as builder

LABEL maintainer "https://github.com/blacktop"

RUN apk --update add --no-cache mercurial git gcc go \
  && export GOPATH=/go \
  && go get github.com/Shopify/sarama/tools/...

FROM alpine:latest
COPY --from=builder /go/bin/kafka-console-producer /bin/kafka-console-producer
COPY --from=builder /go/bin/kafka-console-partitionconsumer /bin/kafka-console-partitionconsumer
COPY --from=builder /go/bin/kafka-console-consumer /bin/kafka-console-consumer

ENTRYPOINT kafka-console-consumer -brokers=kafka:9092 -topic bro -offset=oldest
