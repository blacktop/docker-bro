Integrate with Redis :construction:
--------------------

:warning: This is not working correctly yet.  It is a [WIP] work in progress

### Start a Redis database

```bash
$ docker run --name redis -d redis:alpine
```

### Start Elasticsearch database and a Logstash redis consumer

```bash
$ docker run -d --name elasticsearch -p 9200:9200 blacktop/elasticsearch:5.5
$ docker run -d --name logstash -p 5044:5044 --link elasticsearch --link redis blacktop/logstash:5.5 \
  logstash -e 'input {  
                 redis {
                   host => "redis"
                   data_type => "list"
                   db => 3
                   key => "bro"
                   codec => "json"
                 }
               }
               output {
                 elasticsearch {
                   hosts => "elasticsearch:9200"
                   index => "bro-%{+YYYY.MM.dd}"
                 }
               }'
```

### Run Bro with the Redis plugin

```bash
$ wget https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap
$ docker run --rm \
         -v `pwd`:/pcap \
         --link redis \
         blacktop/bro:redis -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"
```

> **NOTE:** To watch the redis ingest you can run the following

```bash
$ docker exec -it redis redis-cli monitor
```

=OR=

### You can use `docker-compose`

```bash
$ docker-compose -f docker-compose.redis.yml up
```
