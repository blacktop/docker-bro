Integrate with Redis
--------------------

### Start a Redis DB

```bash
$ docker run --name redis -d redis:alpine
```

### Run Bro with the Redis plugin

```bash
$ wget https://github.com/blacktop/docker-bro/raw/master/pcap/heartbleed.pcap
$ docker run --rm \
         -v `pwd`:/pcap \
         --link redis \
         blacktop/bro:redis -r heartbleed.pcap local "Site::local_nets += { 192.168.11.0/24 }"
```
