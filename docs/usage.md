Usage
-----

### Capture Live Traffic

```bash
docker run --rm --cap-add=NET_RAW --net=host -v `pwd`:/pcap:rw blacktop/bro -i eth0
```

### Use your own pcap

```bash
$ docker run --rm -v /path/to/pcap:/pcap:rw blacktop/bro -r my.pcap local
```

### To use your own `local.bro`

```bash
$ docker run --rm \
  -v `pwd`:/pcap \
  -v `pwd`/local.bro:/usr/local/share/bro/site/local.bro \
  blacktop/bro -r my_pcap.pcap local
```
