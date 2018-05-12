#!/bin/bash

# clean up
rm /tmp/kafka.out || true

echo "===> Starting kafka..."
docker run -d --name kafka \
           -p 9092:9092 \
           -e KAFKA_ADVERTISED_HOST_NAME=localhost \
           -e KAFKA_CREATE_TOPICS=bro:1:1 \
           blacktop/kafka:1.1

sleep 10
echo "===> Starting kafka consumer..."
kafka-console-consumer --brokers=localhost:9092 --topic=bro | tee -a /tmp/kafka.out &

echo "===> Starting bro..."
docker run --rm \
           --link kafka:localhost \
           -v `pwd`/pcap:/pcap \
           blacktop/bro:kafka -F -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"

# sleep 10
# echo "===> Starting kafka consumer..."
# docker run --rm --link kafka:localhost ktools

cat /tmp/kafka.out | grep 'Value:' | cut -d ':' -f 2- | jq 'select(.notice != null) | .notice.note'
