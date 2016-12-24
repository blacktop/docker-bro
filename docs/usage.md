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
